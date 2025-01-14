import 'package:flutter/material.dart';
import 'package:rrbikerental/model/vehicle.dart';

class BookingProvider with ChangeNotifier {
  Vehicle? _vehicle;
  double? _totalPrice;
  int _n = 1;

  // Getter for the selected vehicle
  Vehicle? get vehicle => _vehicle;
  get n => _n;

  set n(value) => _n = value;

  // Setter for the selected vehicle
  void setVehicle(Vehicle? vehicle) {
    _vehicle = vehicle;
    notifyListeners(); // Notify listeners that the vehicle has been updated
  }

  // Getter for total price
  double? get totalPrice => _totalPrice;

  // Setter for total price
  void setTotalPrice(double? price) {
    _totalPrice = price;
    notifyListeners(); // Notify listeners that the total price has been updated
  }

  // Function to calculate the total price based on the selected package, vehicle, and number of days (n)
  void calculateTotalPrice(String package, int n) {
    if (_vehicle == null) return;

    double price = 0.0;

    // Convert string prices to double and calculate the total price based on the selected package
    switch (package) {
      case 'Daily Package':
        price = _parsePrice(_vehicle!.dailyPrice);
        break;
      case 'Weekly Package':
        price = _parsePrice(_vehicle!.weeklyPrice);
        break;
      case 'Fortnightly Package':
        price = _parsePrice(_vehicle!.fortnightlyPrice);
        break;
      case 'Monthly Package':
        price = _parsePrice(_vehicle!.monthlyPrice);
        break;
      default:
        price = 0.0;
    }

    // Calculate total price based on the number of days (n)
    _totalPrice = price * n;

    notifyListeners(); // Notify listeners after calculating total price
  }

  // Helper method to safely parse string prices to double
  double _parsePrice(String price) {
    try {
      return double.parse(price.replaceAll(RegExp(r'[^\d.]'),
          '')); // Remove any non-numeric characters (e.g., currency symbol)
    } catch (e) {
      return 0.0; // If parsing fails, return 0.0
    }
  }
}
