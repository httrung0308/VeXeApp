import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/domain/entities.dart';
import '../../../confirmation/presentation/screens/confirmation_screen.dart';

/// Màn hình thanh toán
class PaymentScreen extends ConsumerStatefulWidget {
  final TripEntity trip;
  final List<int> selectedSeats;
  final int passengerCount;

  const PaymentScreen({super.key, required this.trip, required this.selectedSeats, required this.passengerCount});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedPaymentMethod = 'vnpay';
  final _promoController = TextEditingController();
  bool _agreedToTerms = false;
  bool _isApplyingPromo = false;
  int _discount = 0;

  int get _subtotal => widget.selectedSeats.length * widget.trip.price;
  int get _total => _subtotal - _discount;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() async {
    if (_promoController.text.isEmpty) return;
    setState(() => _isApplyingPromo = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (_promoController.text.toUpperCase() == 'WELCOME20') {
      setState(() {
        _discount = (_subtotal * 0.2).round();
        _isApplyingPromo = false;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Áp dụng mã giảm giá thành công!'), backgroundColor: AppColors.success));
    } else {
      setState(() => _isApplyingPromo = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mã giảm giá không hợp lệ'), backgroundColor: AppColors.error));
    }
  }

  void _onPay() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng đồng ý với điều khoản sử dụng'), backgroundColor: AppColors.warning));
      return;
    }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ConfirmationScreen(trip: widget.trip, selectedSeats: widget.selectedSeats)), (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text('Thanh toán', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phương thức thanh toán', style: AppTypography.h4),
                        const SizedBox(height: AppSpacing.md),
                        _PaymentMethodOption(icon: Icons.qr_code, label: 'VNPay', description: 'Thanh toán qua ví VNPay', isSelected: _selectedPaymentMethod == 'vnpay', onTap: () => setState(() => _selectedPaymentMethod = 'vnpay')),
                        _PaymentMethodOption(icon: Icons.account_balance_wallet, label: 'MoMo', description: 'Thanh toán qua ví MoMo', isSelected: _selectedPaymentMethod == 'momo', onTap: () => setState(() => _selectedPaymentMethod = 'momo')),
                        _PaymentMethodOption(icon: Icons.barcode_reader, label: 'ZaloPay', description: 'Thanh toán qua ZaloPay', isSelected: _selectedPaymentMethod == 'zalopay', onTap: () => setState(() => _selectedPaymentMethod = 'zalopay')),
                        _PaymentMethodOption(icon: Icons.credit_card, label: 'Thẻ ATM/Ngân hàng', description: 'Thanh toán bằng thẻ ATM hoặc thẻ quốc tế', isSelected: _selectedPaymentMethod == 'card', onTap: () => setState(() => _selectedPaymentMethod = 'card')),
                        _PaymentMethodOption(icon: Icons.payments, label: 'Tiền mặt', description: 'Thanh toán trực tiếp tại quầy', isSelected: _selectedPaymentMethod == 'cash', onTap: () => setState(() => _selectedPaymentMethod = 'cash')),
                      ],
                    ),
                  ),
                  _buildPromoSection(),
                  _buildTermsSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: const Border(top: BorderSide(color: AppColors.secondary, width: 3)),
        boxShadow: AppSpacing.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tóm tắt đơn hàng', style: AppTypography.h4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.radiusSmall)),
                child: Text('${widget.trip.formattedDepartureTime} • ${widget.trip.formattedArrivalTime}', style: AppTypography.caption.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [const Icon(Icons.place, size: 16, color: AppColors.primary), const SizedBox(width: AppSpacing.xs), Expanded(child: Text('${widget.trip.fromCity} → ${widget.trip.toCity}', style: AppTypography.body))]),
          const SizedBox(height: AppSpacing.xs),
          Row(children: [const Icon(Icons.directions_bus, size: 16, color: AppColors.textTertiary), const SizedBox(width: AppSpacing.xs), Text(widget.trip.operatorName, style: AppTypography.bodySmall)]),
          const SizedBox(height: AppSpacing.xs),
          Row(children: [const Icon(Icons.event_seat, size: 16, color: AppColors.textTertiary), const SizedBox(width: AppSpacing.xs), Text('${widget.selectedSeats.length} ghế • Ghế ${widget.selectedSeats.join(', ')}', style: AppTypography.bodySmall)]),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Giá vé (${widget.selectedSeats.length} × ${_formatPrice(widget.trip.price)})', style: AppTypography.body), Text(_formatPrice(_subtotal), style: AppTypography.body)],
          ),
          if (_discount > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Giảm giá', style: AppTypography.body.copyWith(color: AppColors.success)), Text('-${_formatPrice(_discount)}', style: AppTypography.body.copyWith(color: AppColors.success))],
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Container(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Tổng cộng', style: AppTypography.h4.copyWith(fontWeight: FontWeight.w700)), Text(_formatPrice(_total), style: AppTypography.priceLarge)],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mã giảm giá', style: AppTypography.h4),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã giảm giá',
                    prefixIcon: const Icon(Icons.local_offer, color: AppColors.textTertiary),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMedium), borderSide: const BorderSide(color: AppColors.border)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: AppSpacing.inputHeight,
                child: OutlinedButton(
                  onPressed: _isApplyingPromo ? null : _applyPromo,
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMedium))),
                  child: _isApplyingPromo ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)) : Text('Áp dụng', style: AppTypography.button.copyWith(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Checkbox(value: _agreedToTerms, onChanged: (value) => setState(() => _agreedToTerms = value ?? false), activeColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
              child: Text.rich(
                TextSpan(
                  text: 'Tôi đồng ý với ',
                  style: AppTypography.bodySmall,
                  children: [
                    TextSpan(text: 'điều khoản sử dụng', style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    TextSpan(text: ' của VeXe', style: AppTypography.bodySmall),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(top: false, child: VexPrimaryButton(text: 'Thanh toán ${_formatPrice(_total)}', leadingIcon: Icons.lock, onPressed: _onPay)),
    );
  }

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return '$formatted đ';
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  const _PaymentMethodOption({required this.icon, required this.label, required this.description, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 24),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(description, style: AppTypography.caption),
                ],
              ),
            ),
            Radio(value: true, groupValue: isSelected, onChanged: (_) => onTap(), activeColor: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
