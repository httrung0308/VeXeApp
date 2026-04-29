import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho danh sách ghế đã chọn
final selectedSeatsProvider = StateProvider<Set<int>>((ref) => {});

/// Provider cho tổng giá booking
final bookingTotalProvider = StateProvider<int>((ref) => 0);

/// Provider cho booking step
final bookingStepProvider = StateProvider<int>((ref) => 1);

/// Provider cho passenger count
final passengerCountProvider = StateProvider<int>((ref) => 1);
