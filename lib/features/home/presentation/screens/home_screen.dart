import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/mock_data.dart';
import '../../../search/presentation/screens/search_results_screen.dart';
import '../providers/home_provider.dart';

/// Màn hình Home - Màn hình chính của ứng dụng VeXe
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime? _selectedDate;
  int _passengerCount = 1;
  bool _isFromFilled = false;
  bool _isToFilled = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _onSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập điểm đi và điểm đến'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          fromCity: _fromController.text,
          toCity: _toController.text,
          date: _selectedDate ?? DateTime.now(),
          passengerCount: _passengerCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final popularRoutes = ref.watch(popularRoutesProvider);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildHeader(),
                const SizedBox(height: AppSpacing.xxl),
                _buildSearchCard(),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text('Tuyến phổ biến', style: AppTypography.h4),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    itemCount: popularRoutes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: _PopularRouteChip(
                          route: popularRoutes[index],
                          onTap: () => _onRouteTap(popularRoutes[index]),
                        ),
                      );
                    },
                  ),
                ),
                const Spacer(),
                _buildPromotionsBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(opacity: 0.05, child: CustomPaint(painter: _PatternPainter())),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.2)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VeXe', style: AppTypography.display.copyWith(color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text('Đặt vé xe khách dễ dàng', style: AppTypography.body.copyWith(color: Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
        boxShadow: AppSpacing.shadowLevel2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: VexLocationField(
                    label: 'Điểm đi',
                    value: _fromController.text,
                    icon: Icons.flight_takeoff,
                    isFilled: _isFromFilled,
                    onTap: () => _showLocationPicker(isFrom: true),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _SwapButton(onTap: _onSwapLocations),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: VexLocationField(
                    label: 'Điểm đến',
                    value: _toController.text,
                    icon: Icons.flight_land,
                    isFilled: _isToFilled,
                    onTap: () => _showLocationPicker(isFrom: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: VexDateField(
                    label: 'Ngày đi',
                    value: _selectedDate,
                    onTap: () => _showDatePicker(),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _PassengerSelector(
                    count: _passengerCount,
                    onTap: () => _showPassengerPicker(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            VexPrimaryButton(
              text: 'Tìm chuyến xe',
              leadingIcon: Icons.search,
              onPressed: _onSearch,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionsBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.bottomSafeArea + AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.secondary, Color(0xFF27AE60)]),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        boxShadow: [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppSpacing.radiusMedium)),
            child: const Icon(Icons.percent, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giảm 20% cho chuyến đầu tiên', style: AppTypography.h4.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Mã: WELCOME20', style: AppTypography.caption.copyWith(color: Colors.white.withValues(alpha: 0.9))),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  void _showLocationPicker({required bool isFrom}) {
    final cities = MockTripData.getCities();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationPickerSheet(
        cities: cities,
        onSelect: (city) {
          setState(() {
            if (isFrom) {
              _fromController.text = city;
              _isFromFilled = true;
            } else {
              _toController.text = city;
              _isToFilled = true;
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: Colors.white, surface: AppColors.surface)),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _showPassengerPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _PassengerPickerSheet(
        initialCount: _passengerCount,
        onSelect: (count) => setState(() => _passengerCount = count),
      ),
    );
  }

  void _onSwapLocations() {
    final from = _fromController.text;
    final to = _toController.text;
    setState(() {
      _fromController.text = to;
      _toController.text = from;
      _isFromFilled = to.isNotEmpty;
      _isToFilled = from.isNotEmpty;
    });
  }

  void _onRouteTap(String route) {
    final parts = route.split(' → ');
    if (parts.length == 2) {
      setState(() {
        _fromController.text = parts[0];
        _toController.text = parts[1];
        _isFromFilled = true;
        _isToFilled = true;
      });
      _onSearch();
    }
  }
}

class _SwapButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SwapButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: const Icon(Icons.swap_horiz, color: AppColors.primary, size: 20),
      ),
    );
  }
}

class _PopularRouteChip extends StatelessWidget {
  final String route;
  final VoidCallback onTap;
  const _PopularRouteChip({required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
          border: Border.all(color: AppColors.border),
          boxShadow: AppSpacing.shadowLevel1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place, size: 14, color: AppColors.secondary),
            const SizedBox(width: AppSpacing.xxs),
            Text(route, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _LocationPickerSheet extends StatelessWidget {
  final List<String> cities;
  final Function(String) onSelect;
  const _LocationPickerSheet({required this.cities, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXL)),
      ),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: AppSpacing.sm), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text('Chọn điểm đi', style: AppTypography.h3)),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => onSelect(cities[index]),
                  leading: const Icon(Icons.place, color: AppColors.primary),
                  title: Text(cities[index], style: AppTypography.body),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSmall)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PassengerSelector extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _PassengerSelector({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppSpacing.radiusMedium), border: Border.all(color: AppColors.border)),
        child: Row(
          children: [
            const Icon(Icons.people_outline, color: AppColors.textTertiary, size: AppSpacing.iconSize),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hành khách', style: AppTypography.caption),
                  const SizedBox(height: 2),
                  Text('$count khách', style: AppTypography.body.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _PassengerPickerSheet extends StatefulWidget {
  final int initialCount;
  final Function(int) onSelect;
  const _PassengerPickerSheet({required this.initialCount, required this.onSelect});

  @override
  State<_PassengerPickerSheet> createState() => _PassengerPickerSheetState();
}

class _PassengerPickerSheetState extends State<_PassengerPickerSheet> {
  late int _count;
  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXL))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(margin: const EdgeInsets.only(bottom: AppSpacing.md), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          Text('Số hành khách', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CounterButton(icon: Icons.remove, onTap: _count > 1 ? () => setState(() => _count--) : null),
              const SizedBox(width: AppSpacing.xl),
              Text('$_count', style: AppTypography.display),
              const SizedBox(width: AppSpacing.xl),
              _CounterButton(icon: Icons.add, onTap: _count < 10 ? () => setState(() => _count++) : null),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: VexPrimaryButton(
              text: 'Xác nhận',
              onPressed: () {
                widget.onSelect(_count);
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _CounterButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Icon(icon, color: onTap != null ? Colors.white : AppColors.textTertiary, size: 24),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..strokeWidth = 0.5;
    const spacing = 40.0;
    for (var i = 0; i < size.width / spacing; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var i = 0; i < size.height / spacing; i++) {
      final y = i * spacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
