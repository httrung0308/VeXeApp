import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/domain/entities.dart';
import '../providers/booking_provider.dart';
import '../../../payment/presentation/screens/payment_screen.dart';

/// Màn hình chọn ghế - Interactive seat selection
class SeatSelectionScreen extends ConsumerStatefulWidget {
  final TripEntity trip;
  final int passengerCount;

  const SeatSelectionScreen({
    super.key,
    required this.trip,
    required this.passengerCount,
  });

  @override
  ConsumerState<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  final Set<int> _selectedSeats = {};
  final Set<int> _occupiedSeats = {};
  bool _showUpperDeck = false;

  @override
  void initState() {
    super.initState();
    _occupiedSeats.addAll(MockTripData.getOccupiedSeats());
  }

  void _onSeatTap(int seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else if (!_occupiedSeats.contains(seatNumber)) {
        if (_selectedSeats.length < widget.passengerCount) {
          _selectedSeats.add(seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bạn chỉ được chọn tối đa ${widget.passengerCount} ghế'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }
    });
  }

  int get _totalPrice => _selectedSeats.length * widget.trip.price;

  @override
  Widget build(BuildContext context) {
    ref.read(selectedSeatsProvider.notifier).state = _selectedSeats;
    ref.read(bookingTotalProvider.notifier).state = _totalPrice;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chọn ghế', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
            Text(widget.trip.operatorName, style: AppTypography.caption),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(widget.trip.formattedDepartureTime, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(Icons.arrow_forward, size: 16, color: AppColors.textTertiary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(widget.trip.formattedArrivalTime, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(widget.trip.busType, style: AppTypography.caption),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.trip.formattedDuration, style: AppTypography.bodySmall),
                    Text(_formatPrice(widget.trip.price), style: AppTypography.price),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(child: _DeckToggleButton(label: 'Tầng dưới', isSelected: !_showUpperDeck, onTap: () => setState(() => _showUpperDeck = false))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _DeckToggleButton(label: 'Tầng trên', isSelected: _showUpperDeck, onTap: () => setState(() => _showUpperDeck = true))),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  VexSeatMap(
                    seatLayout: _getSeatLayout(),
                    selectedSeats: _selectedSeats.toList(),
                    occupiedSeats: _occupiedSeats.toList(),
                    onSeatTap: _onSeatTap,
                    isUpperDeck: _showUpperDeck,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const VexSeatLegend(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -4))]),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selectedSeats.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                      decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSpacing.radiusSmall)),
                      child: Text('${_selectedSeats.length} ghế', style: AppTypography.caption.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text('Ghế ${_selectedSeats.map((e) => e).join(', ')}', style: AppTypography.bodySmall)),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tổng cộng', style: AppTypography.caption),
                      Text(_formatPrice(_totalPrice), style: AppTypography.priceLarge),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: VexPrimaryButton(text: _selectedSeats.isEmpty ? 'Chọn ghế' : 'Tiếp tục (${_selectedSeats.length})', onPressed: _selectedSeats.isNotEmpty ? _onContinue : null)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          trip: widget.trip,
          selectedSeats: _selectedSeats.toList(),
          passengerCount: widget.passengerCount,
        ),
      ),
    );
  }

  List<List<SeatStatus>> _getSeatLayout() {
    return List.generate(6, (row) => List.generate(4, (seat) => SeatStatus.available));
  }

  String _formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return '$formatted đ';
  }
}

class _DeckToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _DeckToggleButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Center(
          child: Text(label, style: AppTypography.body.copyWith(color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        ),
      ),
    );
  }
}
