/// Chứa tất cả dữ liệu phản hồi để dùng trong messageBuilder
class TeleFeedbackData {
  final String feedback;
  final String ratingLabel;
  final List<String> tags;
  final String deviceName;
  final String osVersion;
  final String appVersion;
  final String locale;
  final int? usageSeconds;
  final DateTime? installDate;
  final Map<String, String>? extraInfo;

  TeleFeedbackData({
    required this.feedback,
    required this.ratingLabel,
    required this.tags,
    required this.deviceName,
    required this.osVersion,
    required this.appVersion,
    required this.locale,
    this.usageSeconds,
    this.installDate,
    this.extraInfo,
  });
}

/// Typedef cho hàm builder tùy chỉnh tin nhắn
typedef TeleMessageBuilder = String Function(TeleFeedbackData data);
