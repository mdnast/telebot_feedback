# Telebot Feedback 🚀

Thư viện Flutter hiện đại giúp thu thập phản hồi từ người dùng và gửi trực tiếp về kênh Telegram của bạn. Giải pháp hoàn hảo cho các nhóm nhỏ và nhà phát triển độc lập muốn có vòng lặp phản hồi nhanh chóng mà không cần thiết lập backend phức tạp.

![Feedback UI](https://raw.githubusercontent.com/mdnast/telebot_feedback/main/screenshots/preview.png)

## Tính năng ✨

- **Giao diện hiện đại**: Hiệu ứng mượt mà, thiết kế lấy cảm hứng từ glassmorphism và hỗ trợ haptic feedback.
- **Tích hợp dễ dàng**: Chỉ với một dòng lệnh để hiển thị bottom sheet phản hồi.
- **Tự động thu thập Metadata**: Tự động lấy thông tin thiết bị, phiên bản ứng dụng, thời gian sử dụng và ngôn ngữ.
- **Tùy biến cao**: Thêm các tham số tùy chỉnh của riêng bạn thông qua `extraInfo`.
- **Custom Message (Mới 🌟)**: Tự định nghĩa 100% nội dung tin nhắn gửi về Telegram qua `messageBuilder`.

---

## 🛠️ 1. Hướng dẫn lấy Token & Chat ID chi tiêt

Để thư viện hoạt động, bạn cần **Bot Token** và **Chat ID**. Dưới đây là cách lấy từng loại:

### Cách tạo Bot và lấy Bot Token
1. Mở Telegram, tìm kiếm bot **@BotFather**.
2. Chat `/newbot`.
3. Nhập tên cho Bot (VD: `My Feedback Bot`).
4. Nhập username cho Bot (phải kết thúc bằng chữ `bot`, VD: `my_feedback_123_bot`).
5. Sau khi thành công, bạn sẽ nhận được **API Token**. Hãy lưu lại chuỗi này.

### Cách lấy Chat ID
*   **Cho Group (Nhóm)**: Thêm bot của bạn và bot **@RawDataBot** vào nhóm. Nó sẽ in ra mẩu tin JSON. Tìm dòng `"id": -123456789`. Đó chính là Chat ID.
*   **Cho Channel (Kênh)**: Thêm bot của bạn làm Admin. Đăng 1 tin nhắn rồi **Forward** tin nhắn đó sang bot **@userinfobot**. Bạn sẽ nhận được ID.

---

## 🚀 2. Cách sử dụng cơ bản

```dart
TelebotFeedback.show(
  context,
  botToken: 'YOUR_BOT_TOKEN',
  chatId: 'YOUR_CHAT_ID',
);
```

---

## 🔍 3. Hướng dẫn chuyên sâu: Dữ liệu tự động & Dữ liệu thật

Đây là phần quan trọng nhất để bạn hiểu thư viện lấy cái gì và bạn cần truyền cái gì.

### A. Dữ liệu thư viện TỰ ĐỘNG lấy
Bạn không cần viết code, khi gửi feedback, thư viện luôn đính kèm:
*   **Thiết bị**: Samsung S23, iPhone 15 Pro...
*   **OS**: Android 14, iOS 17...
*   **App Version**: 1.0.0 (12)...
*   **Ngôn ngữ**: vi, en...

### B. Dữ liệu THẬT của App bạn (Cần truyền vào)
Nếu bạn muốn biết "ai gửi" hoặc "họ đã làm gì trước đó", hãy dùng `extraInfo`.

**Ví dụ: Gửi Lịch sử xem (Watch History)**
```dart
// Giả định bạn có dữ liệu thật trong app
String currentEmail = "user@gmail.com";
List<String> watchList = ["Video A", "Video B", "Video C"];

TelebotFeedback.show(
  context,
  botToken: '...',
  chatId: '...',
  extraInfo: {
    'User': currentEmail,
    'Xem gần đây': '\n - ' + watchList.join('\n - '),
    'Trạng thái': 'Đang trực tuyến',
  },
);
```

### C. Tự định nghĩa 100% nội dung tin nhắn (`messageBuilder`) 🌟
Nếu bạn muốn thay đổi hoàn toàn cách hiển thị trên Telegram (đổi icon, đổi thứ tự dòng...), hãy dùng `messageBuilder`.

```dart
TelebotFeedback.show(
  context,
  botToken: '...',
  chatId: '...',
  messageBuilder: (data) {
    return "💎 <b>FEEDBACK MỚI</b>\n"
           "👤 Người gửi: ${data.extraInfo?['User']}\n"
           "📝 Nội dung: ${data.feedback}\n"
           "📱 Máy: ${data.deviceName}";
  },
);
```

---

## 🌍 4. Tùy chỉnh Ngôn ngữ giao diện (Localization)

Nếu bạn muốn đổi chữ trên các nút bấm hoặc câu hỏi ở **giao diện App**, hãy dùng `locale`:

```dart
TelebotFeedback.show(
  context,
  // ...
  locale: TeleFeedbackLocale(
    feedbackQuestion: "Bạn thấy app thế nào?",
    feedbackHint: "Nhập góp ý tại đây nhé...",
    tagEasy: "Dễ dùng",
  ),
);
```

---

## 📦 5. Cài đặt (Installation)

Thêm vào `pubspec.yaml`:

```yaml
telebot_feedback:
  git:
    url: https://github.com/mdnast/telebot_feedback.git
    ref: main
```

## Giấy phép 📄

Giấy phép MIT. Bản quyền thuộc về [mdnast].
