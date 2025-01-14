import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/vehicle.dart';
import '../../view_models/booking_provider.dart';
import '../../view_models/vehicle_provider.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double width = size.width;
    double height = size.height;
    var bookingProvider = Provider.of<BookingProvider>(context);
    Vehicle vehicle = bookingProvider.vehicle!;
    var vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Header(size: size, width: width),
          Text(
            vehicle.name,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: NetworkImage(vehicle.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              SizedBox(
                width: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Year Model: ${vehicle.yearModel}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text('cc: ${vehicle.cc}',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    Text('Mileage: ${vehicle.mileage} kmpl',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    Text('Pickup Location: ${vehicle.pickupLocation}',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    Text(
                      'Security Deposit: Rs ${vehicle.deposit}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total Price: Rs ${bookingProvider.totalPrice}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Booking price(15%): Rs ${15 * bookingProvider.totalPrice! / 100}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TermsAndConditions(),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Footer(),
        ],
      ),
    );
  }
}

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
            Expanded(
              child: Text(
                'I agree to the terms and conditions.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        HoverButton(
          text: 'Book Now',
          onPressed: _isChecked
              ? () {
                  // Add your booking logic here
                  print('Booking confirmed!');
                }
              : null,
          isEnabled: _isChecked,
        ),
      ],
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const HoverButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (widget.isEnabled) {
          setState(() {
            _isHovered = true;
          });
        }
      },
      onExit: (_) {
        if (widget.isEnabled) {
          setState(() {
            _isHovered = false;
          });
        }
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: widget.isEnabled ? widget.onPressed : null,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.isEnabled
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: widget.isEnabled ? Colors.white : Colors.black45,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
