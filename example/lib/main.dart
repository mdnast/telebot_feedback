import 'package:flutter/material.dart';
// Import thư viện của bạn
import 'package:telebot_feedback/telebot_feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Beautiful Feedback UI')),
        body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  // Gọi thư viện tại đây
                  TelebotFeedback.show(
                    context,
                    // Thay Token và ChatID thật của bạn vào đây
                    botToken: '8344768951:AAEOmOp_zUYb8YvbNRVqGzPfJaUrgZIXctk',
                    chatId: '-1003580964774',
                    
                    // Giả lập dữ liệu Tracking (Vì ở Example ko có UsageTracker thật)
                    usageSeconds: 3600, // Ví dụ: Đã dùng 1 tiếng
                    installDate: DateTime.now().subtract(const Duration(days: 10)), // Cài 10 ngày trước
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: Colors.cyan,
                ),
                child: const Text(
                  "Mở Feedback Đẹp", 
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}