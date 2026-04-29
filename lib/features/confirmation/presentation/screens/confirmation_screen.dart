import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/domain/entities.dart';

/// Màn hình xác nhận đặt vé thành công
class ConfirmationScreen extends StatefulWidget {
  final TripEntity trip;
  final List<int> selectedSeats;

  const ConfirmationScreen({super.key, required this.trip, required this.selectedSeats});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _bookingCode = 'VX${DateTime.now().millisecondsSinceEpoch.toString().substring(3).toUpperCase()}';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5)],
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 56),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text('Đặt vé thành công!', style: AppTypography.h2.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Cảm ơn bạn đã tin tưởng VeXe', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildTicketCard(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: VexPrimaryButton(
                text: 'Về trang chủ',
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusXL), boxShadow: AppSpacing.shadowLevel2),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusLarge)),
                child: Column(
                  children: [
                    QrImageView(
                      data: 'VeXe|${_bookingCode}|${widget.trip.id}|${widget.selectedSeats.join(",")}',
                      version: QrVersions.auto,
                      size: 180,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.primary),
                      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppSpacing.radiusSmall)),
                      child: Text(_bookingCode, style: AppTypography.h4.copyWith(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 2)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg + 20, AppSpacing.lg, AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.trip.fromCity, style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(Icons.arrow_forward, size: 20, color: AppColors.secondary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(widget.trip.toCity, style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),
                    _DetailRow(icon: Icons.calendar_today, label: 'Ngày đi', value: _formatDate(widget.trip.departureTime)),
                    _DetailRow(icon: Icons.schedule, label: 'Giờ khởi hành', value: widget.trip.formattedDepartureTime),
                    _DetailRow(icon: Icons.directions_bus, label: 'Nhà xe', value: widget.trip.operatorName),
                    _DetailRow(icon: Icons.event_seat, label: 'Số ghế', value: widget.selectedSeats.join(', ')),
                    _DetailRow(icon: Icons.confirmation_number, label: 'Loại xe', value: widget.trip.busType),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(icon: Icons.share, label: 'Chia sẻ', onTap: _onShare),
        _ActionButton(icon: Icons.calendar_today, label: 'Lịch', onTap: _onAddToCalendar),
        _ActionButton(icon: Icons.download, label: 'Tải về', onTap: _onDownload),
        _ActionButton(icon: Icons.print, label: 'In', onTap: _onPrint),
      ],
    );
  }

  void _onShare() {
    Clipboard.setData(ClipboardData(text: _bookingCode));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã sao chép mã đặt vé'), backgroundColor: AppColors.success));
  }

  void _onAddToCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào lịch'), backgroundColor: AppColors.info));
  }

  void _onDownload() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tải xuống...'), backgroundColor: AppColors.info));
  }

  void _onPrint() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chuẩn bị in...'), backgroundColor: AppColors.info));
  }

  String _formatDate(DateTime date) {
    final weekdays = ['CN', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
    final weekday = weekdays[date.weekday % 7];
    return '$weekday, ${date.day}/${date.month}/${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTypography.bodySmall)),
          Text(value, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMedium), border: Border.all(color: AppColors.border), boxShadow: AppSpacing.shadowLevel1),
            child: Icon(icon, size: 24, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}
