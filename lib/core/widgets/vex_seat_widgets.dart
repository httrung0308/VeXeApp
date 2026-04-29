import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Trạng thái ghế
enum SeatStatus { available, selected, occupied, disabled }

/// Widget hiển thị một ghế trên sơ đồ xe
class VexSeat extends StatelessWidget {
  final int seatNumber;
  final SeatStatus status;
  final int? price;
  final VoidCallback? onTap;
  final bool isUpperDeck;

  const VexSeat({
    super.key,
    required this.seatNumber,
    this.status = SeatStatus.available,
    this.price,
    this.onTap,
    this.isUpperDeck = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status == SeatStatus.available || status == SeatStatus.selected ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(color: _borderColor, width: status == SeatStatus.selected ? 2 : 1),
          boxShadow: status == SeatStatus.selected ? AppSpacing.shadowLevel1 : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_seatIcon, size: 18, color: _iconColor),
            const SizedBox(height: 1),
            Text(
              '$seatNumber',
              style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: _textColor),
            ),
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case SeatStatus.available: return AppColors.seatAvailable;
      case SeatStatus.selected: return AppColors.seatSelected;
      case SeatStatus.occupied: return AppColors.seatOccupied;
      case SeatStatus.disabled: return AppColors.surfaceVariant;
    }
  }

  Color get _borderColor {
    switch (status) {
      case SeatStatus.available: return AppColors.seatAvailableBorder;
      case SeatStatus.selected: return AppColors.seatSelected;
      case SeatStatus.occupied: return AppColors.border;
      case SeatStatus.disabled: return AppColors.border;
    }
  }

  Color get _iconColor {
    switch (status) {
      case SeatStatus.available: return AppColors.secondary;
      case SeatStatus.selected: return AppColors.textOnPrimary;
      case SeatStatus.occupied: return AppColors.seatOccupiedIcon;
      case SeatStatus.disabled: return AppColors.textTertiary;
    }
  }

  Color get _textColor {
    switch (status) {
      case SeatStatus.available: return AppColors.textSecondary;
      case SeatStatus.selected: return AppColors.textOnPrimary;
      case SeatStatus.occupied: return AppColors.textTertiary;
      case SeatStatus.disabled: return AppColors.textTertiary;
    }
  }

  IconData get _seatIcon {
    switch (status) {
      case SeatStatus.available: return Icons.event_seat;
      case SeatStatus.selected: return Icons.check;
      case SeatStatus.occupied: return Icons.event_seat;
      case SeatStatus.disabled: return Icons.block;
    }
  }
}

class VexDriverSeat extends StatelessWidget {
  const VexDriverSeat();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, size: 18, color: AppColors.textTertiary),
          const SizedBox(height: 1),
          Text('Lái', style: AppTypography.caption.copyWith(fontSize: 9, color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}

class VexSeatMap extends StatelessWidget {
  final List<List<SeatStatus>> seatLayout;
  final List<int> selectedSeats;
  final List<int> occupiedSeats;
  final Function(int) onSeatTap;
  final bool isUpperDeck;

  const VexSeatMap({
    super.key,
    required this.seatLayout,
    this.selectedSeats = const [],
    this.occupiedSeats = const [],
    required this.onSeatTap,
    this.isUpperDeck = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isUpperDeck ? AppColors.primary.withValues(alpha: 0.1) : AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          ),
          child: Text(
            isUpperDeck ? 'TẦNG TRÊN' : 'TẦNG DƯỚI',
            style: AppTypography.caption.copyWith(
              color: isUpperDeck ? AppColors.primary : AppColors.secondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Driver section
        Row(
          children: [
            const VexDriverSeat(),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: Container(height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(width: AppSpacing.md),
            Text('Cửa ra', style: AppTypography.caption),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Seat rows
        ...List.generate(seatLayout.length, (rowIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (rowIndex == 2 || rowIndex == 5) const SizedBox(width: AppSpacing.xxl),
                ...List.generate(seatLayout[rowIndex].length, (seatIndex) {
                  final globalSeatNumber = _calculateSeatNumber(rowIndex, seatIndex);
                  final status = _getSeatStatus(globalSeatNumber);
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: VexSeat(
                      seatNumber: globalSeatNumber,
                      status: status,
                      onTap: () => onSeatTap(globalSeatNumber),
                      isUpperDeck: isUpperDeck,
                    ),
                  );
                }),
                if (rowIndex == 2 || rowIndex == 5) const SizedBox(width: AppSpacing.xxl),
              ],
            ),
          );
        }),
      ],
    );
  }

  int _calculateSeatNumber(int rowIndex, int seatIndex) {
    final seatsPerRow = 4;
    final rowOffset = rowIndex * seatsPerRow;
    final seatInRow = seatIndex < 2 ? seatIndex : seatIndex - 1;
    return rowOffset + seatInRow + 1;
  }

  SeatStatus _getSeatStatus(int seatNumber) {
    if (occupiedSeats.contains(seatNumber)) return SeatStatus.occupied;
    if (selectedSeats.contains(seatNumber)) return SeatStatus.selected;
    return SeatStatus.available;
  }
}

class VexSeatLegend extends StatelessWidget {
  const VexSeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMedium), boxShadow: AppSpacing.shadowLevel1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LegendItem(color: AppColors.seatAvailable, borderColor: AppColors.seatAvailableBorder, icon: Icons.event_seat, iconColor: AppColors.secondary, label: 'Còn trống'),
          _LegendItem(color: AppColors.seatSelected, borderColor: AppColors.seatSelected, icon: Icons.check, iconColor: AppColors.textOnPrimary, label: 'Đã chọn'),
          _LegendItem(color: AppColors.seatOccupied, borderColor: AppColors.border, icon: Icons.event_seat, iconColor: AppColors.seatOccupiedIcon, label: 'Đã bán'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final String label;

  const _LegendItem({required this.color, required this.borderColor, required this.icon, required this.iconColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor)),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.caption),
      ],
    );
  }
}
