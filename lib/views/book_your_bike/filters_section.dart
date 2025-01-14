// Existing imports
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../view_models/vehicle_provider.dart';

class FiltersSection extends StatefulWidget {
  const FiltersSection({super.key});

  @override
  _FiltersSectionState createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  // Controllers for the date and time
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropoffController = TextEditingController();

  // For booking duration
  String bookingPackage = 'Daily Package';

  // For transmission types
  List<String> selectedTransmissionTypes = [];

  // For brand selection
  List<String> selectedBrands = [];

  Future<void> _selectDateAndTime(
      BuildContext context, TextEditingController controller) async {
    DateTime now = DateTime.now();

    // Show Date Picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Set the minimum selectable date to today
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Show Time Picker
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        // Combine picked date and time
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Validate that the picked date and time are not in the past
        if (combinedDateTime.isAfter(now)) {
          // Format the date and time
          final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
          String formattedDate = dateFormatter.format(pickedDate);
          String formattedTime = pickedTime.format(context);

          // Set the controller's text with formatted date and time
          controller.text = '$formattedDate $formattedTime';
        } else {
          // Show error if the selected time is invalid
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You cannot select a past time.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double height = size.height;
    double width = size.width;
    bookingPackage = Provider.of<VehicleProvider>(context).package;
    selectedTransmissionTypes =
        Provider.of<VehicleProvider>(context).selectedTransmissionTypes;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 16),
            // Pickup Date and Time
            Text('Pickup Date & Time:'),
            SizedBox(height: 8),
            TextField(
              controller: pickupController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Date & Time',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () =>
                      _selectDateAndTime(context, pickupController),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),
            // Dropoff Date and Time
            Text('Dropoff Date & Time:'),
            SizedBox(height: 8),
            TextField(
              controller: dropoffController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Date & Time',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () =>
                      _selectDateAndTime(context, dropoffController),
                ),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),
            // // Booking Duration
            // Text('Booking Duration:'),
            // Column(
            //   children: [
            //     ListTile(
            //       title: Text('Daily Package'),
            //       leading: Radio<String>(
            //         value: 'Daily Package',
            //         groupValue: bookingPackage,
            //         onChanged: (value) {
            //           setState(() {
            //             bookingPackage = value!;
            //           });
            //         },
            //       ),
            //       onTap: () {
            //         setState(() {
            //           Provider.of<VehicleProvider>(context, listen: false)
            //               .package = 'Daily Package'!;
            //           bookingPackage = 'Daily Package';
            //         });
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Weekly Package'),
            //       leading: Radio<String>(
            //         value: 'Weekly Package',
            //         groupValue: bookingPackage,
            //         onChanged: (value) {
            //           setState(() {
            //             bookingPackage = value!;
            //           });
            //         },
            //       ),
            //       onTap: () {
            //         setState(() {
            //           Provider.of<VehicleProvider>(context, listen: false)
            //               .package = 'Weekly Package'!;
            //           bookingPackage = 'Weekly Package';
            //         });
            //       },
            //     ),
            //     ListTile(
            //       title: Text('Fortnightly Package'),
            //       leading: Radio<String>(
            //         value: 'Fortnightly Package',
            //         groupValue: bookingPackage,
            //         onChanged: (value) {
            //           setState(() {
            //             bookingPackage = value!;
            //           });
            //         },
            //       ),
            //       onTap: () {
            //         setState(() {
            //           Provider.of<VehicleProvider>(context, listen: false)
            //               .package = 'Fortnightly Package';
            //           bookingPackage = 'Fortnightly Package';
            //         });
            //       },
            //     ),
            //     ListTile(
            //       title: const Text('Monthly Package'),
            //       leading: Radio<String>(
            //         value: 'Monthly Package',
            //         groupValue: bookingPackage,
            //         onChanged: (value) {
            //           setState(() {
            //             bookingPackage = value!;
            //           });
            //         },
            //       ),
            //       onTap: () {
            //         setState(() {
            //           Provider.of<VehicleProvider>(context, listen: false)
            //               .package = 'Monthly Package'!;
            //           bookingPackage = 'Monthly Package';
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // Booking Duration
            Text('Booking Duration:'),
            Column(
              children: [
                ListTile(
                  title: Text('Daily Package'),
                  leading: Radio<String>(
                    value: 'Daily Package',
                    groupValue: bookingPackage,
                    onChanged: null, // Disable manual selection
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The package is selected automatically based on the pickup and drop-off dates.',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Weekly Package'),
                  leading: Radio<String>(
                    value: 'Weekly Package',
                    groupValue: bookingPackage,
                    onChanged: null, // Disable manual selection
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The package is selected automatically based on the pickup and drop-off dates.',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Fortnightly Package'),
                  leading: Radio<String>(
                    value: 'Fortnightly Package',
                    groupValue: bookingPackage,
                    onChanged: null, // Disable manual selection
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The package is selected automatically based on the pickup and drop-off dates.',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Monthly Package'),
                  leading: Radio<String>(
                    value: 'Monthly Package',
                    groupValue: bookingPackage,
                    onChanged: null, // Disable manual selection
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'The package is selected automatically based on the pickup and drop-off dates.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 16),
            // Transmission Type
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type:'),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Scooty'),
                  value: selectedTransmissionTypes.contains('scooty'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedTransmissionTypes.add('scooty');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .addType('scooty');
                      } else {
                        selectedTransmissionTypes.remove('scooty');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .removeType('scooty');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Sports'),
                  value: selectedTransmissionTypes.contains('sports'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedTransmissionTypes.add('sports');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .addType('sports');
                      } else {
                        selectedTransmissionTypes.remove('sports');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .removeType('sports');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Adventure'),
                  value: selectedTransmissionTypes.contains('adventure'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedTransmissionTypes.add('adventure');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .addType('adventure');
                      } else {
                        selectedTransmissionTypes.remove('adventure');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .removeType('adventure');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Cruiser'),
                  value: selectedTransmissionTypes.contains('cruiser'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedTransmissionTypes.add('cruiser');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .addType('cruiser');
                      } else {
                        selectedTransmissionTypes.remove('cruiser');
                        Provider.of<VehicleProvider>(context, listen: false)
                            .removeType('cruiser');
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Brands

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const  Text('Brands:'),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title:const Text('Bajaj'),
                  value: selectedBrands.contains('Bajaj'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Bajaj');
                      } else {
                        selectedBrands.remove('Bajaj');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Hero'),
                  value: selectedBrands.contains('Hero'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Hero');
                      } else {
                        selectedBrands.remove('Hero');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Honda'),
                  value: selectedBrands.contains('Honda'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Honda');
                      } else {
                        selectedBrands.remove('Honda');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Harley Davidson'),
                  value: selectedBrands.contains('Harley Davidson'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Harley Davidson');
                      } else {
                        selectedBrands.remove('Harley Davidson');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Royal Enfield'),
                  value: selectedBrands.contains('Royal Enfield'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Royal Enfield');
                      } else {
                        selectedBrands.remove('Royal Enfield');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('TVS'),
                  value: selectedBrands.contains('TVS'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('TVS');
                      } else {
                        selectedBrands.remove('TVS');
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text('Yamaha'),
                  value: selectedBrands.contains('Yamaha'),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
                        selectedBrands.add('Yamaha');
                      } else {
                        selectedBrands.remove('Yamaha');
                      }
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 16),
            // Apply Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                try {
                  if (pickupController.text.isEmpty ||
                      dropoffController.text.isEmpty) {
                    Provider.of<VehicleProvider>(context, listen: false)
                        .isBookButton = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Please select both pickup and dropoff dates.'),
                      ),
                    );
                    return;
                  }

                  // Parse dates from controllers
                  DateTime pickupDateTime =
                      DateTime.parse(pickupController.text.split(' ')[0]);
                  DateTime dropoffDateTime =
                      DateTime.parse(dropoffController.text.split(' ')[0]);

                  // Ensure dropoff time is after pickup time
                  if (pickupDateTime.isAfter(dropoffDateTime)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Dropoff time must be after pickup time.')),
                    );
                    return;
                  }

                  // Calculate duration in days
                  int durationInDays =
                      dropoffDateTime.difference(pickupDateTime).inDays;

                  // Determine package type and iterations
                  String packageType;
                  int n; // Number of package iterations
                  if (durationInDays <= 7) {
                    packageType = "Daily Package";
                    n = durationInDays;
                  } else if (durationInDays <= 15) {
                    packageType = "Weekly Package";
                    n = (durationInDays / 7).ceil();
                  } else if (durationInDays <= 30) {
                    packageType = "Fortnightly Package";
                    n = (durationInDays / 15).ceil();
                  } else {
                    packageType = "Monthly Package";
                    n = (durationInDays / 30).ceil();
                  }

                  final vehicleProvider =
                      Provider.of<VehicleProvider>(context, listen: false);
                  vehicleProvider.isBookButton = true;
                  // Show loading spinner
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(child: CircularProgressIndicator());
                    },
                  );

                  // Fetch vehicles with package type and iterations
                  await vehicleProvider.fetchVehicles(
                    pickupDateTime: pickupDateTime,
                    dropoffDateTime: dropoffDateTime,
                    // packageType: packageType, // Pass packageType to provider
                    // iterations: n, // Pass number of iterations to provider
                    types: selectedTransmissionTypes,
                    brands: selectedBrands,
                  );
                  vehicleProvider.package = packageType;
                  vehicleProvider.n = n;
                  // Close loading spinner
                  Navigator.pop(context);

                  // Show success message
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       content: Text(
                  //           'Filters applied successfully. Package: $packageType, Iterations: $n')),
                  // );
                } catch (e) {
                  // Close loading spinner
                  Navigator.pop(context);

                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error applying filters: $e')),
                  );
                }
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
