library telebot_feedback;

import 'package:flutter/material.dart';
import 'src/feedback_dialog.dart';
import 'src/feedback_locale.dart';

export 'src/feedback_locale.dart';

class TelebotFeedback {
  static void show(
    BuildContext context, {
    required String botToken,
    required String chatId,
    int? usageSeconds,
    DateTime? installDate,
    TeleFeedbackLocale locale = const TeleFeedbackLocale(), // Mặc định là Tiếng Việt
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
        locale: locale,
      ),
    );
  }
}