import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/data/mock_data.dart';

/// Provider cho danh sách tuyến phổ biến
final popularRoutesProvider = Provider<List<String>>((ref) {
  return MockTripData.getPopularRoutes();
});

/// Provider cho danh sách thành phố
final citiesProvider = Provider<List<String>>((ref) {
  return MockTripData.getCities();
});
