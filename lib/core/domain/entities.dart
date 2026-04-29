/// Entity đại diện cho một chuyến xe
class TripEntity {
  final String id;
  final String operatorId;
  final String operatorName;
  final String operatorLogo;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String busType;
  final int availableSeats;
  final int price;
  final double rating;
  final List<String> amenities;

  const TripEntity({
    required this.id,
    required this.operatorId,
    required this.operatorName,
    required this.operatorLogo,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.busType,
    required this.availableSeats,
    required this.price,
    this.rating = 0,
    this.amenities = const [],
  });

  Duration get duration => arrivalTime.difference(departureTime);

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0 && minutes > 0) return '${hours}giờ ${minutes}phút';
    if (hours > 0) return '${hours}giờ';
    return '${minutes}phút';
  }

  String get formattedDepartureTime {
    final hour = departureTime.hour;
    final minute = departureTime.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get formattedArrivalTime {
    final hour = arrivalTime.hour;
    final minute = arrivalTime.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class SeatEntity {
  final int seatNumber;
  final int floor;
  final SeatType type;
  final int price;

  const SeatEntity({required this.seatNumber, required this.floor, required this.type, required this.price});
}

enum SeatType { standard, vip }

class PassengerEntity {
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? note;

  const PassengerEntity({required this.fullName, required this.phoneNumber, this.email, this.note});
}

class BookingEntity {
  final String id;
  final TripEntity trip;
  final List<SeatEntity> seats;
  final List<PassengerEntity> passengers;
  final int totalPrice;
  final BookingStatus status;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.trip,
    required this.seats,
    required this.passengers,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  String get bookingCode => 'VX${id.substring(0, 8).toUpperCase()}';
}

enum BookingStatus { pending, confirmed, cancelled, completed }
