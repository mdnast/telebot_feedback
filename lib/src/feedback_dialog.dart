import 'package:flutter/material.dart';
import 'telegram_service.dart';
import 'feedback_locale.dart';

class TeleFeedbackDialog extends StatefulWidget {
  final String botToken;
  final String chatId;
  final int? usageSeconds;
  final DateTime? installDate;
  final TeleFeedbackLocale locale;

  const TeleFeedbackDialog({
    super.key,
    required this.botToken,
    required this.chatId,
    this.usageSeconds,
    this.installDate,
    this.locale = const TeleFeedbackLocale(),
  });

  @override
  State<TeleFeedbackDialog> createState() => _TeleFeedbackDialogState();
}

class _TeleFeedbackDialogState extends State<TeleFeedbackDialog> {
  int _rating = 5;
  final Set<String> _selectedTagIds = {};
  final TextEditingController _detailController = TextEditingController();
  bool _isSending = false;
  bool _isExpanded = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _onTagSelected(String tagId) {
    setState(() {
      if (_selectedTagIds.contains(tagId)) {
        _selectedTagIds.remove(tagId);
      } else {
        _selectedTagIds.add(tagId);
      }
    });
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1: return '😡 Rất tệ';
      case 2: return '☹️ Không hài lòng';
      case 3: return '😐 Bình thường';
      case 4: return '😊 Hài lòng';
      case 5: return '😍 Tuyệt vời';
      default: return 'Bình thường';
    }
  }

  String _getTagLabel(String id) {
    // Label gửi lên Telegram (Mặc định tiếng Việt theo yêu cầu)
    switch (id) {
      case 'easy': return '🚀 Dễ sử dụng';
      case 'beautiful': return '🎨 Giao diện đẹp';
      case 'fast': return '⚡ Nhanh, mượt';
      case 'hard': return '😕 Hơi khó dùng';
      case 'slow': return '🐢 Chậm / lag';
      case 'ads': return '🧩 Nhiều quảng cáo';
      default: return '📝 Khác';
    }
  }

  String _getTagUiLabel(String id) {
    // Label hiển thị trên UI (Lấy từ Config Locale)
    final loc = widget.locale;
    switch (id) {
      case 'easy': return loc.tagEasy;
      case 'beautiful': return loc.tagBeautiful;
      case 'fast': return loc.tagFast;
      case 'hard': return loc.tagHard;
      case 'slow': return loc.tagSlow;
      case 'ads': return loc.tagAds;
      default: return loc.tagOther;
    }
  }

  List<String> _getCurrentTagIds() {
    return _rating >= 4
        ? ['easy', 'beautiful', 'fast', 'other']
        : ['hard', 'slow', 'ads', 'other'];
  }

  void _submitFeedback() async {
    if (_isSending) return;
    setState(() => _isSending = true);

    try {
      final success = await TelegramService.sendFeedback(
        botToken: widget.botToken,
        chatId: widget.chatId,
        feedback: _detailController.text.isEmpty ? "Không có nội dung" : _detailController.text,
        ratingLabel: _getRatingLabel(_rating),
        tags: _selectedTagIds.map((id) => _getTagLabel(id)).toList(),
        context: context,
        usageSeconds: widget.usageSeconds,
        installDate: widget.installDate,
      );

      if (mounted) {
        setState(() => _isSending = false);
        Navigator.of(context).pop();
        _showCustomToast(context, success, widget.locale);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        _showCustomToast(context, false, widget.locale);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = widget.locale;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF17191C) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            _buildHandleBar(isDark),
            const SizedBox(height: 24),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      loc.feedbackQuestion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildEmojiBtn(1, '😡'),
                        _buildEmojiBtn(2, '☹️'),
                        _buildEmojiBtn(3, '😐'),
                        _buildEmojiBtn(4, '😊'),
                        _buildEmojiBtn(5, '😍'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: _getCurrentTagIds()
                          .map((id) => _buildTagChip(id, isDark))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    if (!_isExpanded)
                      TextButton.icon(
                        onPressed: () => setState(() => _isExpanded = true),
                        icon: const Icon(Icons.notes_rounded, color: Colors.cyan, size: 20),
                        label: Text(
                          loc.feedbackAddDetail,
                          style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      )
                    else
                      _buildTextField(isDark, loc),
                    const SizedBox(height: 20),
                    _SipButton(
                      onPressed: _isSending ? null : _submitFeedback,
                      isLoading: _isSending,
                      text: loc.feedbackSend,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(bool isDark) => Container(
    width: 44, height: 5,
    decoration: BoxDecoration(
      color: isDark ? Colors.white12 : Colors.black12,
      borderRadius: BorderRadius.circular(10),
    ),
  );

  Widget _buildEmojiBtn(int val, String emoji) {
    final isSelected = _rating == val;
    return GestureDetector(
      onTap: () {
        setState(() {
          if ((_rating >= 4) != (val >= 4)) _selectedTagIds.clear();
          _rating = val;
        });
      },
      child: AnimatedScale(
        scale: isSelected ? 1.25 : 0.9,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: ColorFiltered(
          // Hiệu ứng Grayscale nếu không chọn
          colorFilter: isSelected
              ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
              : const ColorFilter.matrix(<double>[
                  0.21, 0.72, 0.07, 0, 0,
                  0.21, 0.72, 0.07, 0, 0,
                  0.21, 0.72, 0.07, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
          child: Text(emoji, style: const TextStyle(fontSize: 44)),
        ),
      ),
    );
  }

  Widget _buildTagChip(String id, bool isDark) {
    final isSelected = _selectedTagIds.contains(id);
    return GestureDetector(
      onTap: () => _onTagSelected(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyan.withOpacity(0.15)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.cyan : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          _getTagUiLabel(id),
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.cyan : (isDark ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(bool isDark, TeleFeedbackLocale loc) => Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
    ),
    child: TextField(
      controller: _detailController,
      minLines: 3, maxLines: 5, autofocus: true,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: loc.feedbackHint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(16),
      ),
    ),
  );
}

class _SipButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const _SipButton({required this.isLoading, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : Text(
              text,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
    );
  }
}

void _showCustomToast(BuildContext context, bool success, TeleFeedbackLocale loc) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        success ? loc.feedbackSuccess : loc.feedbackError,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: success ? Colors.green.shade600 : Colors.red.shade600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ),
  );
}