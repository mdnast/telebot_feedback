library telebot_feedback;

import 'package:flutter/material.dart';
import 'src/feedback_dialog.dart';
import 'src/feedback_locale.dart';
import 'src/feedback_data.dart';

export 'src/feedback_locale.dart';
export 'src/feedback_data.dart';

class TelebotFeedback {
  static void show(
    BuildContext context, {
    required String botToken,
    required String chatId,
    int? usageSeconds,
    DateTime? installDate,
    Map<String, String>? extraInfo,
    TeleMessageBuilder? messageBuilder,
    TeleFeedbackLocale locale =
        const TeleFeedbackLocale(), // Mặc định là Tiếng Việt
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TeleFeedbackDialog(
        botToken: botToken,
        chatId: chatId,
        usageSeconds: usageSeconds,
        installDate: installDate,
        extraInfo: extraInfo,
        messageBuilder: messageBuilder,
        locale: locale,
      ),
    );
  }
}
