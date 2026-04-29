import '../domain/entities.dart';

/// Mock data cho các chuyến xe
class MockTripData {
  MockTripData._();

  static List<TripEntity> getSampleTrips() {
    final now = DateTime.now();
    return [
      TripEntity(
        id: 'trip_001',
        operatorId: 'op_001',
        operatorName: 'Phương Trang',
        operatorLogo: 'PT',
        fromCity: 'TP. Hồ Chí Minh',
        toCity: 'Đà Nẵng',
        departureTime: now.copyWith(hour: 6, minute: 0),
        arrivalTime: now.copyWith(hour: 18, minute: 30),
        busType: 'Giường nằm 2 tầng',
        availableSeats: 23,
        price: 450000,
        rating: 4.7,
        amenities: ['wifi', 'toilet', 'water', 'snack'],
      ),
      TripEntity(
        id: 'trip_002',
        operatorId: 'op_002',
        operatorName: 'Hoa Mai',
        operatorLogo: 'HM',
        fromCity: 'TP. Hồ Chí Minh',
        toCity: 'Đà Nẵng',
        departureTime: now.copyWith(hour: 7, minute: 30),
        arrivalTime: now.copyWith(hour: 19, minute: 45),
        busType: 'Giường nằm điều hòa',
        availableSeats: 15,
        price: 480000,
        rating: 4.5,
        amenities: ['wifi', 'toilet', 'water', 'blanket'],
      ),
      TripEntity(
        id: 'trip_003',
        operatorId: 'op_001',
        operatorName: 'Phương Trang',
        operatorLogo: 'PT',
        fromCity: 'TP. Hồ Chí Minh',
        toCity: 'Đà Nẵng',
        departureTime: now.copyWith(hour: 8, minute: 0),
        arrivalTime: now.copyWith(hour: 20, minute: 15),
        busType: 'Giường nằm 2 tầng',
        availableSeats: 8,
        price: 450000,
        rating: 4.7,
        amenities: ['wifi', 'toilet', 'water', 'snack'],
      ),
      TripEntity(
        id: 'trip_004',
        operatorId: 'op_003',
        operatorName: 'Sao Việt',
        operatorLogo: 'SV',
        fromCity: 'TP. Hồ Chí Minh',
        toCity: 'Đà Nẵng',
        departureTime: now.copyWith(hour: 21, minute: 0),
        arrivalTime: now.copyWith(hour: 9, minute: 30),
        busType: 'Giường nằm',
        availableSeats: 32,
        price: 380000,
        rating: 4.2,
        amenities: ['toilet', 'water'],
      ),
    ];
  }

  static List<String> getPopularRoutes() {
    return [
      'TP. Hồ Chí Minh → Đà Nẵng',
      'Hà Nội → TP. Hồ Chí Minh',
      'Đà Nẵng → Hội An',
      'Nha Trang → Đà Lạt',
      'Hà Nội → Hải Phòng',
    ];
  }

  static List<String> getCities() {
    return [
      'TP. Hồ Chí Minh',
      'Hà Nội',
      'Đà Nẵng',
      'Hải Phòng',
      'Nha Trang',
      'Đà Lạt',
      'Cần Thơ',
      'Hội An',
      'Vũng Tàu',
      'Huế',
    ];
  }

  static List<int> getOccupiedSeats() {
    return [3, 5, 8, 12, 15, 22, 25, 28, 33, 38, 42];
  }
}
