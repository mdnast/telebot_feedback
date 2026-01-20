import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'feedback_data.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TelegramService {
  static Future<bool> sendFeedback({
    required String botToken,
    required String chatId,
    required String feedback,
    required String ratingLabel,
    required List<String> tags,
    required BuildContext context,
    int? usageSeconds,
    DateTime? installDate,
    Map<String, String>? extraInfo,
    TeleMessageBuilder? messageBuilder,
  }) async {
    if (botToken.isEmpty || chatId.isEmpty) return false;

    // 1. Lấy thông tin thiết bị
    String deviceName = 'Unknown';
    String osVersion = 'Unknown';
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine;
        osVersion = 'iOS ${iosInfo.systemVersion}';
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
    }

    // 2. Lấy App Version
    String appVersion = '1.0.0';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      debugPrint('Error getting package info: $e');
    }

    // 3. Xử lý Ngôn ngữ & Flag
    String locale = Localizations.localeOf(context).toString();
    String flag = _getFlag(locale);
    String localeDisplay = flag.isNotEmpty ? '$flag $locale' : locale;

    // 4. Tracking Info
    String trackingInfo = "";
    if (usageSeconds != null) {
      final h = (usageSeconds / 3600).floor();
      final m = ((usageSeconds % 3600) / 60).floor();
      trackingInfo +=
          "• Tổng thời gian dùng: ${h > 0 ? "$h giờ $m phút" : "$m phút"}\n";
    }

    if (installDate != null) {
      final age = DateTime.now().difference(installDate).inDays;
      trackingInfo += "⏳ <b>Tuổi App:</b> $age ngày kể từ khi cài đặt\n";
    }

    final tagsStr = tags.isNotEmpty ? tags.join(', ') : 'Không có';

    // 5. Thêm Extra Info (nếu có)
    String extraStr = "";
    if (extraInfo != null && extraInfo.isNotEmpty) {
      extraStr = "\n\n<b>🔍 THÔNG TIN THÊM</b>\n";
      extraInfo.forEach((key, value) {
        extraStr += "• $key: $value\n";
      });
    }

    // 6. Template tin nhắn HTML (An toàn hơn Markdown)
    final message = "🌟 <b>Đánh giá:</b> $ratingLabel\n"
        "🏷️ <b>Nhãn:</b> $tagsStr\n"
        "📝 <b>Nội dung:</b> ${_escapeHtml(feedback)}\n\n"
        "📊 <b>THỐNG KÊ NGƯỜI DÙNG</b>\n"
        "$trackingInfo"
        "📱 <b>Thiết bị:</b> $deviceName ($osVersion)\n"
        "🌍 <b>Ngôn ngữ:</b> $localeDisplay | ℹ️ <b>Bản:</b> $appVersion"
        "$extraStr";

    // 7. Sử dụng builder nếu có
    String finalMessage = message;
    if (messageBuilder != null) {
      finalMessage = messageBuilder(TeleFeedbackData(
        feedback: feedback,
        ratingLabel: ratingLabel,
        tags: tags,
        deviceName: deviceName,
        osVersion: osVersion,
        appVersion: appVersion,
        locale: localeDisplay,
        usageSeconds: usageSeconds,
        installDate: installDate,
        extraInfo: extraInfo,
      ));
    }

    // Gửi đi
    try {
      final url =
          Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': finalMessage,
          'parse_mode': 'HTML',
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static String _escapeHtml(String text) {
    return text
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;");
  }

  static String _getFlag(String locale) {
    if (locale.contains('vi')) return '🇻🇳';
    if (locale.contains('en')) return '🇺🇸';
    if (locale.contains('es')) return '🇪🇸';
    if (locale.contains('hi')) return '🇮🇳';
    if (locale.contains('ja')) return '🇯🇵';
    if (locale.contains('ko')) return '🇰🇷';
    return '';
  }
}
