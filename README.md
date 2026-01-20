# 🚀 Telebot Feedback for Flutter

[![Pub Version](https://img.shields.io/pub/v/telebot_feedback?color=blue&style=flat-square)](https://pub.dev/packages/telebot_feedback)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat-square&logo=Flutter&logoColor=white)](https://flutter.dev)

Thư viện Flutter giúp tích hợp tính năng **Gửi phản hồi (Feedback)** từ người dùng trực tiếp về **Telegram Group** hoặc **Channel** của bạn một cách dễ dàng và chuyên nghiệp.

Giao diện hiện đại, hỗ trợ Emoji đánh giá, Thẻ chọn nhanh (Tags), và tự động thu thập thông tin thiết bị (Device Info), phiên bản ứng dụng.

---

## ✨ Tính năng nổi bật

*   🎨 **Giao diện hiện đại**: Emoji Grayscale, Chip tags màu sắc, Animation mượt mà.
*   📱 **Auto Device Info**: Tự động lấy tên máy (Samsung S23, iPhone 14...), hệ điều hành, phiên bản App.
*   🌍 **Đa ngôn ngữ**: Hỗ trợ tùy chỉnh ngôn ngữ (Mặc định Tiếng Việt, có thể cấu hình sang Anh, Nhật...).
*   📊 **User Tracking**: Gửi kèm thời gian sử dụng app và ngày cài đặt để phân tích hành vi.
*   ⚡ **Siêu tốc**: Gửi ngầm (Fire & Forget), không làm gián đoạn trải nghiệm người dùng.

---

## 🛠️ 1. Hướng dẫn lấy Token & Chat ID (Bắt buộc)

Để thư viện hoạt động, bạn cần tạo một con Bot Telegram và lấy ID của nơi bạn muốn nhận tin nhắn (Group hoặc Channel).

### 🤖 Bước 1: Lấy Bot Token
1. Mở Telegram, tìm kiếm từ khóa **@BotFather** (có tích xanh).
2. Gõ lệnh `/newbot` và làm theo hướng dẫn:
    *   Đặt tên hiển thị (VD: *My App Feedback*).
    *   Đặt username (phải kết thúc bằng chữ `bot`, VD: *myapp_feedback_bot*).
3. Sau khi xong, **BotFather** sẽ đưa cho bạn một chuỗi ký tự dài. Đó là **API Token**.
    *   *Ví dụ: 123456789:ABCdefGHIjklMNOpqrstUVwxYZ*

### 🆔 Bước 2: Lấy Chat ID
Bạn có thể chọn gửi về **Group** (Nhóm chat) hoặc **Channel** (Kênh thông báo).

#### 🅰️ Cách lấy ID của Group (Nhóm):
1. Thêm con Bot bạn vừa tạo vào Group.
2. Thêm tiếp con bot tên là **@RawDataBot** vào nhóm đó.
3. Nó sẽ in ra một đoạn JSON. Tìm dòng `"chat": { "id": -100xxxxxx }`.
4. Số đó (bao gồm cả dấu trừ) chính là **Chat ID**.
5. (Lấy xong nhớ kick con @RawDataBot ra cho đỡ rối).

#### 🅱️ Cách lấy ID của Channel (Kênh):
1. Thêm Bot của bạn vào Channel và cấp quyền **Administrator** (Quản trị viên) để nó có thể gửi tin nhắn.
2. Đăng một tin nhắn bất kỳ lên Channel đó.
3. **Forward** (Chuyển tiếp) tin nhắn đó từ Channel tới con bot tên là **@userinfobot**.
4. Bot sẽ trả về thông tin, tìm dòng **Id**. Đó chính là **Channel ID**.

> [!IMPORTANT]
> **Lưu ý**: Chat ID của Group/Channel thường bắt đầu bằng dấu trừ và số 100 (VD: `-1001234567`). Hãy copy cả dấu trừ.

---

## 📦 2. Cài đặt vào dự án (Installation)

Mở file `pubspec.yaml` trong dự án Flutter của bạn và thêm vào phần `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 👇 Thêm thư viện từ Git:
  telebot_feedback:
    git:
      url: https://github.com/mdnast/telebot_feedback.git
      ref: main
```

Sau đó chạy lệnh:
```bash
flutter pub get
```

---

## 🚀 3. Cách sử dụng (Usage)

### Cấu hình Android (Quan trọng ⚠️)
Để gửi được tin nhắn, ứng dụng cần quyền Internet. Mở file `android/app/src/main/AndroidManifest.xml` và thêm dòng này vào trên thẻ `<application>`:

```xml
<manifest xmlns:android="...">
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application ...>
```

### Code mẫu
Gọi hàm `TelebotFeedback.show` ở bất kỳ đâu (ví dụ: khi bấm nút Cài đặt hoặc Góp ý).

```dart
import 'package:flutter/material.dart';
import 'package:telebot_feedback/telebot_feedback.dart';

// ... Trong nút bấm của bạn:
ElevatedButton(
  onPressed: () {
    TelebotFeedback.show(
      context,
      // 1. Cấu hình Telegram (Bắt buộc)
      botToken: 'YOUR_BOT_TOKEN', // Token lấy từ BotFather
      chatId: 'YOUR_CHAT_ID',      // ID Group hoặc Channel
      
      // 2. Dữ liệu theo dõi (Tùy chọn - Tự lấy từ logic app của bạn)
      usageSeconds: 3600, // Ví dụ: User đã dùng 1 tiếng (3600s)
      installDate: DateTime(2023, 1, 1), // Ngày cài app
    );
  },
  child: const Text("Gửi Feedback"),
)
```

---

## 🌍 4. Tùy chỉnh Ngôn ngữ (Localization)

Mặc định thư viện sử dụng Tiếng Việt. Nếu bạn muốn chuyển sang Tiếng Anh hoặc thay đổi nội dung text, hãy sử dụng tham số `locale`:

```dart
TelebotFeedback.show(
  context,
  botToken: '...',
  chatId: '...',
  
  // Tùy chỉnh text tại đây
  locale: TeleFeedbackLocale(
    feedbackQuestion: "How is your experience?",
    feedbackHint: "Please share your thoughts...",
    feedbackSend: "Send Feedback",
    feedbackSuccess: "Thank you for your feedback!",
    tagEasy: "Easy to use",
    tagBeautiful: "Beautiful UI",
    tagFast: "Fast & Smooth",
    tagHard: "Hard to use",
    tagSlow: "Slow / Laggy",
    tagAds: "Too many Ads",
    tagOther: "Other",
  ),
);
```

---

## 📝 5. Kết quả nhận được trên Telegram

Khi người dùng gửi feedback, tin nhắn sẽ có dạng như sau:

```text
🌟 Đánh giá: 😍 Tuyệt vời
🏷️ Nhãn: 🚀 Dễ sử dụng, 🎨 Giao diện đẹp
📝 Nội dung: App dùng rất mượt, tôi rất thích!

📊 THỐNG KÊ NGƯỜI DÙNG
• Tổng thời gian dùng: 1 giờ 30 phút
⏳ Tuổi App: 15 ngày kể từ khi cài đặt

📱 Thiết bị: Samsung SM-S911U (Android 14)
🌍 Ngôn ngữ: 🇻🇳 vi | ℹ️ Bản: 1.0.0 (1)
```

---

## 🤝 Đóng góp (Contribution)

Mọi đóng góp đều được hoan nghênh! Hãy tạo **Pull Request** hoặc mở **Issue** nếu bạn tìm thấy lỗi.

## 📄 License

Thư viện được phát hành dưới bản quyền **MIT License**.
