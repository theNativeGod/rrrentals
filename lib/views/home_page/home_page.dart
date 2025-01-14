import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rrbikerental/views/book_your_bike/book_your_bike_page.dart';
import 'package:rrbikerental/views/home_page/faq.dart';
import 'package:rrbikerental/static.dart';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../view_models/vehicle_provider.dart';
import '../../widgets/footer.dart';
import '../../widgets/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection(Widget child) {
    return SlideTransition(
      position: _offsetAnimation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(size: size, width: width),
              // bookYourBike(width, context),
              home_page(width, context),

              //footer
              _buildAnimatedSection(
                Footer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bookYourBike(width, context) {
    return BookYourBikePage();
  }

  Column home_page(double width, BuildContext context) {
    return Column(
      children: [
        _buildAnimatedSection(
          Stack(
            children: [
              Container(
                width: width,
                height: 850,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/harley.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: width,
                height: 850,
                color: Colors.black.withOpacity(0.5),
              ),
              Positioned(
                bottom: 225,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(width * .08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'RENT.\n',
                          children: [
                            TextSpan(
                              text: 'RIDE.',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const TextSpan(text: ' REVIVE.')
                          ],
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 40),
                      HoverButton(
                        onTap: () {
                          context.go('/bookyourbike');
                        },
                        text: 'Book Your Bike',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 80),
        _buildAnimatedSection(const SectionHeading(text: 'Select Your Type')),
        const SizedBox(height: 30),
        _buildAnimatedSection(
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VehicleType(
                    width: width, text: 'Scooty', image: 'jupiter.jpeg'),
                VehicleType(width: width, text: 'Sports', image: 'apache.png'),
                VehicleType(
                    width: width, text: 'Adventure', image: 'xpulse.jpg'),
                VehicleType(
                    width: width, text: 'Cruiser', image: 'meteor.jpeg'),
                // VehicleType(
                //     width: width, text: 'Premium Bikes', image: 'harley.jpeg'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildAnimatedSection(
            const SectionHeading(text: 'Seamless Ride Booking')),
        const SizedBox(height: 30),
        _buildAnimatedSection(
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 600,
                  child: Image.asset('assets/images/map.png'),
                ),
                const SizedBox(width: 40),
                SizedBox(
                    height: 600, child: Image.asset('assets/images/book.jpeg')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildAnimatedSection(
            const SectionHeading(text: 'Here’s What Our Riders Say')),
        const SizedBox(height: 30),
        _buildAnimatedSection(
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: reviews
                  .map((review) => Review(
                        name: review['name']!,
                        text: review['text']!,
                      ))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 40),
        _buildAnimatedSection(const SectionHeading(text: 'FAQs')),
        const SizedBox(height: 30),
        _buildAnimatedSection(FAQPage()),
        const SizedBox(height: 80),
      ],
    );
  }
}

class Review extends StatefulWidget {
  const Review({
    required this.name,
    required this.text,
    super.key,
  });

  final String name;
  final String text;

  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _isHovered ? 350 : 300, // Increase height on hover
        width: _isHovered ? 350 : 300, // Increase width on hover
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).canvasColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 8,
              spreadRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '“', // Opening quotation mark
                    style: TextStyle(
                      fontSize: _isHovered ? 34 : 30, // Grow font size on hover
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(
                    text: widget.text, // Main text
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: _isHovered ? 13 : 11, // Adjust font size
                          color: Colors.black,
                        ),
                  ),
                  TextSpan(
                    text: '”', // Closing quotation mark
                    style: TextStyle(
                      fontSize: _isHovered ? 34 : 30, // Grow font size on hover
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: _isHovered ? 18 : 16, // Adjust font size
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.text,
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class VehicleType extends StatefulWidget {
  const VehicleType({
    super.key,
    required this.width,
    required this.text,
    required this.image,
  });

  final double width;
  final String text;
  final String image;

  @override
  _VehicleTypeState createState() => _VehicleTypeState();
}

class _VehicleTypeState extends State<VehicleType> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Provider.of<VehicleProvider>(context, listen: false).removeAllTypes();
          Provider.of<VehicleProvider>(context, listen: false)
              .addType(widget.text.toLowerCase());
          context.go('/bookyourbike');
        },
        child: Stack(
          children: [
            Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.identity()
                    ..scale(_isHovered ? 1.1 : 1.0), // Zoom effect on hover
                  transformAlignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/${widget.image}',
                    fit: BoxFit.cover,
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
            ),
            Container(
              height: 300,
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  const HoverButton({
    required this.onTap,
    required this.text,
    super.key,
  });

  final VoidCallback onTap;
  final String text;

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered
              ? (Matrix4.identity()..scale(1.1))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ),
    );
  }
}
