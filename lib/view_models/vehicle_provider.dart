import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/vehicle.dart'; // Ensure you have this file with the Vehicle class

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<Vehicle> get vehicles => _vehicles;
  List<String> _selectedTransmissionTypes = [];
  int _n = 1;

  bool _isBookButton = false;

  String _package = 'Daily Package';

  get package => _package;

  get selectedTransmissionTypes => _selectedTransmissionTypes;

  get isBookButton => _isBookButton;

  get n => _n;

  set package(value) {
    _package = value;
    print('package: $value');
    notifyListeners();
  }

  set selectedTransmissionTypes(value) {
    _selectedTransmissionTypes = value;
    notifyListeners();
  }

  addType(String type) {
    _selectedTransmissionTypes.add(type);
    notifyListeners();
  }

  removeAllTypes() {
    _selectedTransmissionTypes.clear();
    notifyListeners();
  }

  removeType(String type) {
    _selectedTransmissionTypes.remove(type);
    notifyListeners();
  }

  set isBookButton(value) => _isBookButton = value;

  set n(value) => _n = value;

  Future<void> fetchVehicles({
    required DateTime pickupDateTime,
    required DateTime dropoffDateTime,
    required List<String> types,
    required List<String> brands,
  }) async {
    try {
      // Reference Firestore collection
      final collection = FirebaseFirestore.instance.collection('vehicles');

      // Query the vehicles collection with filters
      Query query = collection;

      if (types.isNotEmpty) {
        query = query.where('type', whereIn: types);
      }

      // Fetch the documents
      final QuerySnapshot snapshot = await query.get();
      final List<Vehicle> fetchedVehicles = snapshot.docs.map((doc) {
        return Vehicle.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Filter by brand names in vehicle names
      final List<Vehicle> brandFilteredVehicles =
          fetchedVehicles.where((vehicle) {
        return brands.isEmpty ||
            brands.any((brand) =>
                vehicle.name.toLowerCase().contains(brand.toLowerCase()));
      }).toList();

      // Filter vehicles based on availability
      final List<Vehicle> availableVehicles =
          brandFilteredVehicles.where((vehicle) {
        return vehicle.isAvailable(pickupDateTime, dropoffDateTime);
      }).toList();

      // Update the vehicles list
      _vehicles = availableVehicles;
      notifyListeners();
    } catch (e) {
      print('Error fetching vehicles: $e');
      throw e;
    }
  }

  // Fetch all vehicles without any filters
  Future<void> fetchAllVehicles() async {
    try {
      // Reference Firestore collection
      final collection = FirebaseFirestore.instance.collection('vehicles');

      // Fetch all documents without any filters
      final QuerySnapshot snapshot = await collection.get();
      print('here\'s the snapshot ${snapshot.docs.first.data()}');
      final List<Vehicle> fetchedVehicles = snapshot.docs.map((doc) {
        print('id: ${(doc.data() as Map<String, dynamic>)['name']}');

        return Vehicle.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Update the vehicles list with all vehicles
      _vehicles = fetchedVehicles;
      notifyListeners();
    } catch (e) {
      print('Error fetching all vehicles: $e');
      throw e;
    }
  }

  Future<void> fetchVehiclesByType() async {
    List<String> types = _selectedTransmissionTypes;
    try {
      // Reference Firestore collection
      final collection = FirebaseFirestore.instance.collection('vehicles');

      // Query the vehicles collection with filters
      Query query = collection;

      // If the types list is not empty, filter based on vehicle type
      if (types.isNotEmpty) {
        query = query.where('type', whereIn: types);
      }

      // Fetch the documents
      final QuerySnapshot snapshot = await query.get();
      final List<Vehicle> fetchedVehicles = snapshot.docs.map((doc) {
        return Vehicle.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Update the vehicles list
      _vehicles = fetchedVehicles;
      notifyListeners();
    } catch (e) {
      print('Error fetching vehicles by type: $e');
      throw e;
    }
  }
}
