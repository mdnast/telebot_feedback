# 🚀 Telebot Feedback for Flutter

[![Pub Version](https://img.shields.io/pub/v/telebot_feedback?color=blue&style=flat-square)](https://pub.dev/packages/telebot_feedback)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white)](https://flutter.dev)

Thư viện Flutter hiện đại giúp thu thập phản hồi từ người dùng và gửi trực tiếp về kênh **Telegram** của bạn. Giải pháp hoàn hảo để xây dựng vòng lặp phản hồi nhanh chóng mà không cần backend phức tạp.

---

## ✨ Tính năng nổi bật

*   🎨 **Giao diện hiện đại**: Hiệu ứng mượt mà, thiết kế lấy cảm hứng từ glassmorphism và hỗ trợ haptic feedback.
*   📱 **Auto Metadata**: Tự động lấy tên máy (Samsung S23, iPhone 15...), hệ điều hành, phiên bản App và ngôn ngữ.
*   🔍 **Dữ liệu linh hoạt**: Dễ dàng đính kèm các tham số tùy chỉnh như User ID, Lịch sử xem thông qua `extraInfo`.
*   🌟 **Custom Message**: Tự định nghĩa 100% nội dung tin nhắn gửi về Telegram qua `messageBuilder`.
*   🌍 **Đa ngôn ngữ**: Hỗ trợ tùy chỉnh toàn bộ văn bản giao diện (Mặc định: Tiếng Việt).

---

## 🛠️ 1. Cài đặt Bot & Lấy ID (Trong 2 phút)

Để hệ thống hoạt động, bạn cần chuẩn bị **Token** và **Chat ID**.

### 🤖 Bước 1: Tạo Bot Telegram
1. Chat với **[@BotFather](https://t.me/botfather)**, gõ `/newbot`.
2. Đặt tên và username cho bot.
3. Lưu lại **API Token** bạn nhận được.

### 🆔 Bước 2: Lấy Chat ID (Nơi nhận tin nhắn)
*   **Nếu gửi về Group**: Thêm bot của bạn @GetIDs Bot vào nhóm. Copy dãy số `id` (VD: `-100123456789`).
*   **Nếu gửi về Channel**: Thêm bot làm Admin. Forward 1 tin nhắn từ Channel sang **[@userinfobot](https://t.me/userinfobot)** để lấy ID.

---

## 🚀 2. Cài đặt & Sử dụng

### 📦 Bước 1: Thêm dependency vào `pubspec.yaml`

Tùy vào cách bạn muốn sử dụng, hãy chọn một trong các cách sau:

**Cách 1: Sử dụng qua Git (Khuyên dùng)**
```yaml
dependencies:
  telebot_feedback:
    git:
      url: https://github.com/mdnast/telebot_feedback.git
      ref: main
```

**Cách 2: Sử dụng Local (Khi bạn đang chỉnh sửa thư viện)**
```yaml
dependencies:
  telebot_feedback:
    path: ../telebot_feedback  # Đường dẫn đến thư mục chứa thư viện
```

> [!IMPORTANT]
> Sau khi thêm, hãy đừng quên chạy lệnh **`flutter pub get`** trong terminal.

### 🛠️ Bước 2: Import và Sử dụng

```dart
import 'package:telebot_feedback/telebot_feedback.dart';

// Gọi ở bất cứ đâu khi có context (thường là trong onPressed của nút bấm)
TelebotFeedback.show(
  context,
  botToken: 'YOUR_BOT_TOKEN',
  chatId: 'YOUR_CHAT_ID',
);
```

---

## 🔍 3. Hướng dẫn chuyên sâu & Tùy biến

### 📊 Dữ liệu Tự động vs Dữ liệu Thủ công
Thư viện tự động thu thập thông tin thiết bị. Để gửi thêm dữ liệu riêng của App, hãy dùng `extraInfo`.

**Ví dụ: Gửi ID người dùng và Lịch sử xem bài viết**
```dart
TelebotFeedback.show(
  context,
  botToken: '...',
  chatId: '...',
  extraInfo: {
    'User': 'user_vip_99',
    'Xem gần đây': '\n • Bài viết số 1\n • Video hướng dẫn Flutter',
    'Trạng thái': 'Đang trực tuyến',
  },
);
```

### 🎨 Tự định nghĩa Tin nhắn (`messageBuilder`) 
Nếu bạn muốn thay đổi "tận gốc" giao diện tin nhắn trên Telegram, hãy sử dụng `messageBuilder`.

```dart
TelebotFeedback.show(
  context,
  botToken: '...',
  chatId: '...',
  messageBuilder: (data) {
    return "💎 <b>PHẢN HỒI MỚI</b>\n"
           "👤 Người gửi: ${data.extraInfo?['User'] ?? 'Ẩn danh'}\n"
           "📝 Nội dung: ${data.feedback}\n"
           "📱 Thiết bị: ${data.deviceName}";
  },
);
```

> [!TIP]
> Bạn có thể sử dụng các thẻ HTML như `<b>`, `<i>`, `<code>` để làm tin nhắn nổi bật và chuyên nghiệp hơn.

---

## 🌍 4. Tùy chỉnh Ngôn ngữ (Localization)

Dễ dàng thay đổi câu hỏi hoặc nhãn nút bấm trên giao diện Bottom Sheet:

```dart
TelebotFeedback.show(
  context,
  // ...
  locale: TeleFeedbackLocale(
    feedbackQuestion: "Trải nghiệm của bạn thế nào?",
    feedbackHint: "Để lại lời nhắn cho mình...",
    tagEasy: "Rất dễ dùng",
    tagBeautiful: "Giao diện đẹp",
  ),
);
```

---

## � Giấy phép (License)

Thư viện được phát hành dưới bản quyền **MIT License**.

---
<p align="center">
  Made with ❤️ for Flutter Developers
</p>
