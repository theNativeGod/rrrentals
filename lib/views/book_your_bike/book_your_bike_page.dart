import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rrbikerental/model/vehicle.dart';
import 'package:rrbikerental/view_models/booking_provider.dart';
import 'package:rrbikerental/view_models/vehicle_provider.dart';

import '../../widgets/footer.dart';
import '../../widgets/header.dart';
import 'filters_section.dart';

class BookYourBikePage extends StatefulWidget {
  const BookYourBikePage({super.key});

  @override
  State<BookYourBikePage> createState() => _BookYourBikePageState();
}

class _BookYourBikePageState extends State<BookYourBikePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Provider.of<VehicleProvider>(context, listen: false).fetchVehiclesByType();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Provider.of<VehicleProvider>(context, listen: false).removeAllTypes();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double width = size.width;
    var vehiclesProvider = Provider.of<VehicleProvider>(context);
    List<Vehicle> vehicles = vehiclesProvider.vehicles;

    // Calculate the number of columns based on the width
    int crossAxisCount = (width / 300).floor();
    crossAxisCount = crossAxisCount > 4 ? 4 : crossAxisCount;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Header(size: size, width: width),
            Text(
              'Book Your Bike',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FiltersSection(),
                  Container(
                    width: width - 300 - 100,
                    height: 1500,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: vehicles.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio:
                                  0.8, // Adjust aspect ratio for rectangle
                            ),
                            padding: const EdgeInsets.all(10),
                            itemCount: vehicles.length,
                            itemBuilder: (ctx, i) {
                              return VehicleCard(vehicles[i], vehiclesProvider);
                            },
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class VehicleCard extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleProvider vehiclesProvider;

  const VehicleCard(this.vehicle, this.vehiclesProvider, {super.key});

  @override
  _VehicleCardState createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Transform.scale(
        scale: isHovered ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(8)),
                      image: DecorationImage(
                        image: NetworkImage(widget.vehicle.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Text Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vehicle.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'cc: ${widget.vehicle.cc}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                'Mileage: ${widget.vehicle.mileage}kmpl',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Text(
                            getPricingText(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Book Now Button
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.vehicle.availableNumber > 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(8)),
                      ),
                    ),
                    onPressed: widget.vehicle.availableNumber > 0
                        ? () {
                            if (!Provider.of<VehicleProvider>(context,
                                    listen: false)
                                .isBookButton) {
                              // Show a Snackbar to prompt the user to select the pickup and drop-off date and time
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please select the pickup and drop-off date and time.'),
                                ),
                              );
                            } else {
                              // Proceed with the existing functionality
                              Provider.of<BookingProvider>(context,
                                      listen: false)
                                  .setVehicle(widget.vehicle);

                              var vehicleProvider =
                                  Provider.of<VehicleProvider>(context,
                                      listen: false);
                              Provider.of<BookingProvider>(context,
                                      listen: false)
                                  .n = vehicleProvider.n;
                              Provider.of<BookingProvider>(context,
                                      listen: false)
                                  .calculateTotalPrice(vehicleProvider.package,
                                      vehicleProvider.n);

                              context.go('/vehicledetails');
                            }
                          }
                        : null,
                    child: Text(
                      widget.vehicle.availableNumber > 0
                          ? 'Book Now'
                          : 'Not Available',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getPricingText() {
    String packageText = '';
    switch (widget.vehiclesProvider.package) {
      case 'Daily Package':
        packageText = 'Daily:\nRs ${widget.vehicle.dailyPrice}';
        break;
      case 'Weekly Package':
        packageText = 'Weekly:\nRs ${widget.vehicle.weeklyPrice}';
        break;
      case 'Fortnightly Package':
        packageText = 'Fortnightly:\nRs ${widget.vehicle.fortnightlyPrice}';
        break;
      case 'Monthly Package':
        packageText = 'Monthly:\nRs ${widget.vehicle.monthlyPrice}';
        break;
    }

    var iter = Provider.of<VehicleProvider>(context, listen: false).n;
    return '$packageText x $iter';
  }
}
