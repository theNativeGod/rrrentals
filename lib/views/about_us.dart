import 'package:flutter/material.dart';
import 'package:rrbikerental/widgets/footer.dart';
import 'package:rrbikerental/widgets/header.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Header(size: size, width: width),
              Text(
                'About Us',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 450,
                    width: 450,
                    child: Image.asset(
                      'assets/images/about1.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: width * .3,
                    child: Text(
                        textAlign: TextAlign.center,
                        'Founded in 2016 with a few personal bikes, RR Bike Rental has grown significantlyover the past 8 years in Kolkata\'s rental industry. We are proud to be the only government-authorized bike rental provider with a fleet of over 100 bikes, our mission is to deliver a smooth and comfortable experience to every customer. Excitingly, we\'re expanding to new cities across West Bengal, including Kharagpur, Kalyani, Siliguri, Durgapur, and more!',
                        style:
                            Theme.of(context).textTheme.bodyLarge!.copyWith()),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 450,
                    width: 450,
                    child: Image.asset('assets/images/about2.jpeg',
                        fit: BoxFit.cover),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Footer(),
            ],
          ),
        ),
      ),
    ));
  }
}
