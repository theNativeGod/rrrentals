import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String name;
  final String yearModel;
  final String mileage;
  final String deposit;
  final String pickupLocation;
  final String image;
  final String dailyPrice;
  final String weeklyPrice;
  final String fortnightlyPrice;
  final String monthlyPrice;
  final String cc;
  final String type;
  final int totalNumber;
  int availableNumber; // Mutable available number
  final List<Map<String, DateTime>> bookings; // Booking list

  Vehicle({
    required this.id,
    required this.name,
    required this.yearModel,
    required this.mileage,
    required this.deposit,
    required this.pickupLocation,
    required this.image,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.fortnightlyPrice,
    required this.monthlyPrice,
    required this.cc,
    required this.type,
    required this.totalNumber,
    required this.availableNumber,
    required this.bookings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'yearModel': yearModel,
      'mileage': mileage,
      'deposit': deposit,
      'pickupLocation': pickupLocation,
      'image': image,
      'dailyPrice': dailyPrice,
      'weeklyPrice': weeklyPrice,
      'fortnightlyPrice': fortnightlyPrice,
      'monthlyPrice': monthlyPrice,
      'cc': cc,
      'type': type,
      'totalNumber': totalNumber,
      'availableNumber': availableNumber,
      'bookings': bookings
          .map((booking) => {
                'pickup': booking['pickup']!.toIso8601String(),
                'dropoff': booking['dropoff']!.toIso8601String(),
              })
          .toList(),
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json, String id) {
    return Vehicle(
      id: id,
      name: json['name'],
      yearModel: json['yearModel'],
      mileage: json['mileage'],
      deposit: json['deposit'],
      pickupLocation: json['pickupLocation'],
      image: json['image'],
      dailyPrice: json['dailyPrice'],
      weeklyPrice: json['weeklyPrice'],
      fortnightlyPrice: json['fortnightlyPrice'],
      monthlyPrice: json['monthlyPrice'],
      cc: json['cc'],
      type: json['type'],
      totalNumber: json['totalNumber'],
      availableNumber: json['availableNumber'],
      bookings: (json['bookings'] as List<dynamic>?)?.map((booking) {
            return {
              'pickup': DateTime.parse(booking['pickup']),
              'dropoff': DateTime.parse(booking['dropoff']),
            };
          }).toList() ??
          [],
    );
  }

  isAvailable(DateTime pickup, DateTime dropoff) {
    int overlappingBookings = bookings.where((booking) {
      DateTime bookedPickup = booking['pickup']!;
      DateTime bookedDropoff = booking['dropoff']!;
      return !(dropoff.isBefore(bookedPickup) || pickup.isAfter(bookedDropoff));
    }).length;

    // Calculate the available number
    availableNumber = totalNumber - overlappingBookings;

    // Update Firestore with the new available number
    FirebaseFirestore.instance
        .collection('vehicles')
        .doc(id)
        .update({'availableNumber': availableNumber});

    return availableNumber > 0;
  }

  Future<void> addBooking(DateTime pickup, DateTime dropoff) async {
    bool av = isAvailable(pickup, dropoff);
    if (av) {
      bookings.add({'pickup': pickup, 'dropoff': dropoff});

      // Update Firestore with the new bookings and availability
      await FirebaseFirestore.instance.collection('vehicles').doc(id).update({
        'bookings': bookings
            .map((booking) => {
                  'pickup': booking['pickup']!.toIso8601String(),
                  'dropoff': booking['dropoff']!.toIso8601String(),
                })
            .toList(),
        'availableNumber': totalNumber - bookings.length,
      });

      availableNumber = totalNumber - bookings.length; // Update locally
    } else {
      throw Exception('Vehicle is not available for the selected dates.');
    }
  }
}
