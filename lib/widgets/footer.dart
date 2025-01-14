import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
      color: Colors.grey.shade900,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              padding:const  EdgeInsets.all(8),
              height: 100,
              width: 100,
              child: Image.asset('assets/images/logo.png')),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Contact Us',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Terms and Conditions',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Text(
              //     'FAQs',
              //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //           color: Colors.white70,
              //           decoration: TextDecoration.underline,
              //         ),
              //   ),
              // ),
              // GestureDetector(
              //   onTap: () {},
              //   child: Text(
              //     'List Your Vehicle',
              //     style: Theme.of(context)
              //         .textTheme
              //         .bodyLarge!
              //         .copyWith(
              //           color: Colors.white70,
              //           decoration: TextDecoration.underline,
              //         ),
              //   ),
              // ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+91 1234567890',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'support@fastfinite.in',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
