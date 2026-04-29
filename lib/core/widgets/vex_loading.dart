import 'package:flutter/material.dart';
import '../constants/constants.dart';

/// Shimmer loading effect cho skeleton screens
class VexShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const VexShimmerLoading({super.key, required this.child, this.isLoading = true});

  @override
  State<VexShimmerLoading> createState() => _VexShimmerLoadingState();
}

class _VexShimmerLoadingState extends State<VexShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [Color(0xFFE2E8F0), Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3].map((e) => e.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}

class VexTripCardSkeleton extends StatelessWidget {
  const VexTripCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: AppSpacing.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusSmall))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 100, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 60, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: AppColors.surfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 24, width: 50, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(height: 12, width: 60, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                ],
              ),
              Container(height: 12, width: 80, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(height: 24, width: 50, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 4),
                  Container(height: 12, width: 30, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: AppColors.surfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 24, width: 80, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(AppSpacing.radiusSmall))),
              Container(height: 24, width: 60, decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4))),
            ],
          ),
        ],
      ),
    );
  }
}

class VexBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const VexBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Trang chủ', isActive: currentIndex == 0, onTap: () => onTap(0)),
              _NavBarItem(icon: Icons.confirmation_number_outlined, activeIcon: Icons.confirmation_number, label: 'Chuyến xe', isActive: currentIndex == 1, onTap: () => onTap(1)),
              _NavBarItem(icon: Icons.local_offer_outlined, activeIcon: Icons.local_offer, label: 'Khuyến mãi', isActive: currentIndex == 2, onTap: () => onTap(2)),
              _NavBarItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Cá nhân', isActive: currentIndex == 3, onTap: () => onTap(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(isActive ? activeIcon : icon, size: AppSpacing.iconSizeLarge, color: isActive ? AppColors.primary : AppColors.textTertiary),
            ),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.caption.copyWith(color: isActive ? AppColors.primary : AppColors.textTertiary, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
