import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'models/hotel_model.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/hotel_details_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/confirmation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TravelEaseApp());
}

class TravelEaseApp extends StatelessWidget {
  const TravelEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelEase',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );

          case '/main':
            final index = settings.arguments as int? ?? 0;
            return MaterialPageRoute(
              builder: (_) => MainNavigationScreen(initialIndex: index),
            );

          case '/hotel_details':
            final hotel = settings.arguments as Hotel?;
            return MaterialPageRoute(
              builder: (_) => HotelDetailsScreen(hotel: hotel),
            );

          case '/booking':
            final hotel = settings.arguments as Hotel?;
            return MaterialPageRoute(
              builder: (_) => BookingScreen(hotel: hotel),
            );

          case '/confirmation':
            final hotel = settings.arguments as Hotel?;
            return MaterialPageRoute(
              builder: (_) => ConfirmationScreen(hotel: hotel),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
            );
        }
      },
    );
  }
}
