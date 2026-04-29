import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/domain/entities.dart';
import '../../../booking/presentation/screens/seat_selection_screen.dart';

/// Màn hình kết quả tìm kiếm chuyến xe
class SearchResultsScreen extends StatefulWidget {
  final String fromCity;
  final String toCity;
  final DateTime date;
  final int passengerCount;

  const SearchResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.passengerCount,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final List<TripEntity> _trips = [];
  bool _isLoading = true;
  String _sortBy = 'departure';
  final Set<String> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _trips.addAll(MockTripData.getSampleTrips());
        _isLoading = false;
      });
    }
  }

  void _onFilterTap(String filter) {
    setState(() {
      if (_selectedFilters.contains(filter)) {
        _selectedFilters.remove(filter);
      } else {
        _selectedFilters.add(filter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.fromCity} → ${widget.toCity}', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
            Text(_formatDate(widget.date), style: AppTypography.caption),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: _showSortOptions)],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  VexFilterChip(label: 'Sớm nhất', icon: Icons.schedule, isSelected: _selectedFilters.contains('early'), onTap: () => _onFilterTap('early')),
                  const SizedBox(width: AppSpacing.sm),
                  VexFilterChip(label: 'Giá thấp', icon: Icons.attach_money, isSelected: _selectedFilters.contains('price'), onTap: () => _onFilterTap('price')),
                  const SizedBox(width: AppSpacing.sm),
                  VexFilterChip(label: 'Đánh giá cao', icon: Icons.star, isSelected: _selectedFilters.contains('rating'), onTap: () => _onFilterTap('rating')),
                  const SizedBox(width: AppSpacing.sm),
                  VexFilterChip(label: 'Ghế trống', icon: Icons.event_seat, isSelected: _selectedFilters.contains('seats'), onTap: () => _onFilterTap('seats')),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? ListView.builder(padding: const EdgeInsets.all(AppSpacing.md), itemCount: 5, itemBuilder: (context, index) => const VexTripCardSkeleton())
                : _trips.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(padding: const EdgeInsets.all(AppSpacing.md), itemCount: 5, itemBuilder: (context, index) => const VexTripCardSkeleton());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: const BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
            child: const Icon(Icons.search_off, size: 48, color: AppColors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Không tìm thấy chuyến xe', style: AppTypography.h3),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
            child: Text('Hãy thử điều chỉnh bộ lọc hoặc chọn ngày khác', style: AppTypography.body.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
          ),
          const SizedBox(height: AppSpacing.xl),
          VexSecondaryButton(text: 'Đặt lại', isFullWidth: false, onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) setState(() => _isLoading = false);
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          return VexTripCard(
            operatorName: trip.operatorName,
            operatorLogo: trip.operatorLogo,
            departureTime: trip.formattedDepartureTime,
            arrivalTime: trip.formattedArrivalTime,
            duration: trip.formattedDuration,
            availableSeats: trip.availableSeats,
            price: trip.price,
            busType: trip.busType,
            rating: trip.rating,
            accentColor: AppColors.secondary,
            onTap: () => _onTripTap(trip),
          );
        },
      ),
    );
  }

  void _onTripTap(TripEntity trip) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionScreen(
          trip: trip,
          passengerCount: widget.passengerCount,
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXL))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: AppSpacing.lg),
            Text('Sắp xếp theo', style: AppTypography.h3),
            const SizedBox(height: AppSpacing.md),
            _SortOption(icon: Icons.schedule, label: 'Giờ khởi hành', isSelected: _sortBy == 'departure', onTap: () { setState(() => _sortBy = 'departure'); Navigator.pop(context); }),
            _SortOption(icon: Icons.attach_money, label: 'Giá thấp nhất', isSelected: _sortBy == 'price', onTap: () { setState(() => _sortBy = 'price'); Navigator.pop(context); }),
            _SortOption(icon: Icons.star, label: 'Đánh giá cao nhất', isSelected: _sortBy == 'rating', onTap: () { setState(() => _sortBy = 'rating'); Navigator.pop(context); }),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'CN'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${date.day}/${date.month}';
  }
}

class _SortOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _SortOption({required this.icon, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(label, style: AppTypography.body.copyWith(color: isSelected ? AppColors.primary : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
    );
  }
}
