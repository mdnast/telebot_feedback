class TeleFeedbackLocale {
  final String feedbackQuestion;
  final String feedbackHint;
  final String feedbackAddDetail;
  final String feedbackSend;
  final String feedbackSuccess;
  final String feedbackError;
  
  // Tags
  final String tagEasy;
  final String tagBeautiful;
  final String tagFast;
  final String tagHard;
  final String tagSlow;
  final String tagAds;
  final String tagOther;

  const TeleFeedbackLocale({
    this.feedbackQuestion = "Bạn cảm thấy ứng dụng thế nào?",
    this.feedbackHint = "Hãy chia sẻ thêm suy nghĩ của bạn...",
    this.feedbackAddDetail = "Thêm chi tiết",
    this.feedbackSend = "Gửi phản hồi",
    this.feedbackSuccess = "Cảm ơn bạn đã đóng góp!",
    this.feedbackError = "Có lỗi xảy ra, vui lòng thử lại!",
    this.tagEasy = "🚀 Dễ sử dụng",
    this.tagBeautiful = "🎨 Giao diện đẹp",
    this.tagFast = "⚡ Nhanh, mượt",
    this.tagHard = "😕 Hơi khó dùng",
    this.tagSlow = "🐢 Chậm / lag",
    this.tagAds = "🧩 Nhiều quảng cáo",
    this.tagOther = "📝 Khác",
  });
}