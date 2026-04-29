import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Trip Card - hiển thị thông tin chuyến xe
class VexTripCard extends StatelessWidget {
  final String operatorName;
  final String operatorLogo;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int availableSeats;
  final int price;
  final String busType;
  final double rating;
  final VoidCallback? onTap;
  final Color? accentColor;

  const VexTripCard({
    super.key,
    required this.operatorName,
    required this.operatorLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.availableSeats,
    required this.price,
    required this.busType,
    this.rating = 0,
    this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
          boxShadow: AppSpacing.shadowLevel1,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Left accent bar
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor ?? AppColors.secondary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusLarge),
                    bottomLeft: Radius.circular(AppSpacing.radiusLarge),
                  ),
                ),
              ),
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Operator info row
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                            ),
                            child: Center(
                              child: Text(
                                operatorLogo.isNotEmpty ? operatorLogo[0] : 'V',
                                style: AppTypography.h4.copyWith(color: accentColor ?? AppColors.primary),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(operatorName, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(busType, style: AppTypography.caption),
                              ],
                            ),
                          ),
                          if (rating > 0) ...[
                            const Icon(Icons.star, size: 14, color: AppColors.accent),
                            const SizedBox(width: 2),
                            Text(rating.toStringAsFixed(1), style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.md),
                      // Time and duration row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(departureTime, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700)),
                                Text('Khởi hành', style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(duration, style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                                      child: Icon(Icons.directions_bus, size: 16, color: AppColors.textTertiary),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                Text('Du lịch', style: AppTypography.caption.copyWith(color: AppColors.textTertiary)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(arrivalTime, style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700)),
                                Text('Đến', style: AppTypography.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(height: 1),
                      const SizedBox(height: AppSpacing.md),
                      // Bottom row - seats and price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SeatBadge(count: availableSeats),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(_formatPrice(price), style: AppTypography.priceLarge),
                              Text('/khách', style: AppTypography.caption),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return '$price';
  }
}

class _SeatBadge extends StatelessWidget {
  final int count;

  const _SeatBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isLowStock = count <= 5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: isLowStock ? AppColors.warningLight : AppColors.successLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_seat, size: 14, color: isLowStock ? AppColors.accentDark : AppColors.secondary),
          const SizedBox(width: 4),
          Text(
            '$count ghế trống',
            style: AppTypography.caption.copyWith(
              color: isLowStock ? AppColors.accentDark : AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class VexSearchSummary extends StatelessWidget {
  final int tripCount;
  final String fromCity;
  final String toCity;

  const VexSearchSummary({super.key, required this.tripCount, required this.fromCity, required this.toCity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tìm thấy $tripCount chuyến xe', style: AppTypography.h4),
                const SizedBox(height: 2),
                Text('$fromCity → $toCity', style: AppTypography.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_list, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Bộ lọc', style: AppTypography.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VexFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const VexFilterChip({super.key, required this.label, this.isSelected = false, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xxs),
            ],
            Text(label, style: AppTypography.bodySmall.copyWith(color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
            if (isSelected) ...[
              const SizedBox(width: AppSpacing.xxs),
              const Icon(Icons.close, size: 14, color: AppColors.textOnPrimary),
            ],
          ],
        ),
      ),
    );
  }
}
