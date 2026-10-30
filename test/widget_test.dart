import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travelease/main.dart';
import 'package:travelease/screens/home_screen.dart';
import 'package:travelease/screens/search_screen.dart';
import 'package:travelease/screens/booking_screen.dart';
import 'package:travelease/screens/profile_screen.dart';
import 'package:travelease/theme/app_theme.dart';
import 'package:travelease/data/mock_data.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('TravelEaseApp renders splash screen initially',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TravelEaseApp());
    expect(find.text('TravelEase'), findsOneWidget);
    expect(find.text('Explore  •  Book  •  Travel'), findsOneWidget);
    expect(find.textContaining('Your next adventure'), findsOneWidget);
    expect(find.textContaining('is just a tap away'), findsOneWidget);

    // Verify dark background for full-bleed tropical splash
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.black);
  });

  testWidgets('Splash screen tap triggers navigation to main screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TravelEaseApp());
    await tester.pump();

    // Tap anywhere on splash screen
    await tester.tap(find.text('TravelEase'));
    await tester.pumpAndSettle();

    // Should now be on Main / Home screen
    expect(find.text('Find The'), findsOneWidget);
    expect(find.text('Perfect'), findsOneWidget);
  });

  testWidgets('HomeScreen category buttons switch categories properly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hotels'), findsOneWidget);
    expect(find.text('Flights'), findsOneWidget);
    expect(find.text('Rental Car'), findsOneWidget);

    // Tap Flights category chip
    await tester.tap(find.text('Flights'));
    await tester.pumpAndSettle();

    // Flights banner should appear
    expect(find.text('Flights to Bali (DPS)'), findsOneWidget);

    // Tap Rental Car category chip
    await tester.tap(find.text('Rental Car'));
    await tester.pumpAndSettle();

    // Car rental banner should appear
    expect(find.text('SUV & Convertibles'), findsOneWidget);
  });

  testWidgets('HomeScreen notification bell opens notification sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap notification bell icon
    final bellIcon = find.byIcon(Icons.notifications_none_rounded);
    expect(bellIcon, findsOneWidget);
    await tester.tap(bellIcon);
    await tester.pumpAndSettle();

    // Notification sheet title and items should appear
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Flash Deal Alert! ⚡'), findsOneWidget);
  });

  testWidgets('SearchScreen interactive filters and reset work',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const SearchScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Reset button should exist
    expect(find.text('Reset'), findsOneWidget);

    // Tap rating chip
    await tester.tap(find.text('4.5+ ★'));
    await tester.pumpAndSettle();

    // Tap Reset
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Tap Show Places button
    final showButton = find.textContaining('Show');
    expect(showButton, findsOneWidget);
    await tester.tap(showButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Available Places'), findsOneWidget);
  });

  testWidgets('BookingScreen date pickers and rooms work',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const BookingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Booking Details'), findsOneWidget);
    expect(find.text('Deluxe Room'), findsOneWidget);
    expect(find.text('Ocean Premier Suite'), findsOneWidget);

    // Tap on Ocean Suite room option
    await tester.tap(find.text('Ocean Premier Suite'));
    await tester.pumpAndSettle();

    // Proceed button updates with new rate
    expect(find.textContaining('Proceed to Pay'), findsOneWidget);
  });

  testWidgets('ProfileScreen settings and bookings modal work',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const ProfileScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Albert'), findsOneWidget);
    expect(find.text('My Bookings'), findsOneWidget);
    expect(find.text('Payment Methods'), findsOneWidget);

    // Tap My Bookings
    await tester.tap(find.text('My Bookings'));
    await tester.pumpAndSettle();

    expect(find.text('Bali Exotica Resort'), findsOneWidget);
  });

  testWidgets('HomeScreen renders on narrow viewport without overflow and displays INR currency',
      (WidgetTester tester) async {
    // Narrow 360 x 800 phone screen (typical mobile screen that previously overflowed by 21px)
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: const HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all categories render
    expect(find.text('Hotels'), findsOneWidget);
    expect(find.text('Flights'), findsOneWidget);
    expect(find.text('Rental Car'), findsOneWidget);

    // Verify Indian Rupee symbol is displayed on hotel cards and flash deals
    expect(find.textContaining('₹2500'), findsOneWidget);
    expect(find.textContaining('₹1800'), findsOneWidget);

    // Verify no RenderFlex overflow exceptions occurred during render
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'BookingScreen renders on narrow viewport without overflow and displays updated INR prices',
      (WidgetTester tester) async {
    // Narrow 360 x 800 phone screen (typical mobile screen that had 9.8px overflow)
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.themeData,
        home: BookingScreen(hotel: MockData.recommendedHotels[1]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Booking Details'), findsOneWidget);
    expect(find.text('Alpine Crest Villa'), findsOneWidget);
    expect(find.text('Guests & Rooms'), findsOneWidget);
    expect(find.textContaining('2 Adults, 1 Child'), findsOneWidget);
    expect(find.textContaining('₹3500'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
