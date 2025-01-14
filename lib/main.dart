import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rrbikerental/firebase_options.dart';
import 'package:rrbikerental/view_models/booking_provider.dart';
import 'package:rrbikerental/view_models/vehicle_provider.dart';
import 'package:rrbikerental/views/about_us.dart';
import 'package:rrbikerental/views/home_page/home_page.dart';
import 'package:rrbikerental/views/vehicle_details_page/vehicle_details_page.dart';

import 'views/book_your_bike/book_your_bike_page.dart';

Future<void> setPersistence() async {
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setPersistence();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/', // Specify the initial route
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/bookyourbike',
          builder: (context, state) => const BookYourBikePage(),
        ),
        GoRoute(
          path: '/vehicledetails',
          builder: (context, state) => const VehicleDetailsPage(),
        ),
        GoRoute(
          path: '/aboutus',
          builder: (context, state) => const AboutUsPage(),
        ),
      ],
      errorBuilder: (context, state) {
        // Fallback for unknown routes
        return Scaffold(
          body: Center(child: Text('Page not found: ${state.matchedLocation}')),
        );
      },
    );
    return MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider(
            create: (_) => VehicleProvider()), // Example provider
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        // You can add more providers as needed
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xffF3BB0C),
          fontFamily: 'Montserrat',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffF3BB0C)),
          useMaterial3: true,
        ),
      ),
    );
    // return MaterialApp(
    //   title: 'rrbikerental',
    //   theme: ThemeData(),
    //   home: VehicleUploadScreen(),
    // );
  }
}
