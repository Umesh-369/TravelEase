import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/hotel_card.dart';
import '../widgets/flash_deal_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  const HomeScreen({
    super.key,
    this.onSearchTap,
    this.onProfileTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _unreadNotifications = 2;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Hotels', 'icon': Icons.hotel_rounded},
    {'label': 'Flights', 'icon': Icons.flight_outlined},
    {'label': 'Rental Car', 'icon': Icons.directions_car_outlined},
  ];

  final List<Map<String, String>> _notificationsList = [
    {
      'title': 'Flash Deal Alert! ⚡',
      'body': 'Get up to 50% discount in Phuket Grand Sunset Haven.',
      'time': '10m ago',
    },
    {
      'title': 'Upcoming Journey ✈️',
      'body': 'Pack your bags! Check-in starts on 20 May 2026.',
      'time': '2h ago',
    },
    {
      'title': 'Promo Code Unlocked 🎟️',
      'body': 'Use code "SUMMER26" to claim ₹500 off on next booking.',
      'time': '1d ago',
    },
  ];

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (_unreadNotifications > 0)
                        TextButton(
                          onPressed: () {
                            setSheetState(() {});
                            setState(() {
                              _unreadNotifications = 0;
                            });
                          },
                          child: const Text(
                            'Mark all as read',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._notificationsList.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.bgLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLime,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              size: 18,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        color: AppTheme.textDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      item['time']!,
                                      style: const TextStyle(
                                        color: AppTheme.textLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['body']!,
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showVoiceSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLime,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryLime.withValues(alpha: 0.5),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_rounded,
                    color: AppTheme.darkNavy,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Listening...',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try saying "Luxury hotel in Bali" or "Mountain villas"',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFlashDealInfo() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppTheme.discountRed),
              SizedBox(width: 8),
              Text(
                'Flash Sale Active!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Special limited-time rates expire in 02:45:30. Book any flash deal now to enjoy complimentary luxury breakfast and 50% discount.',
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Header: Avatar, Greeting, Notification Bell Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (widget.onProfileTap != null) {
                          widget.onProfileTap!();
                        } else {
                          Navigator.of(context).pushNamed(
                            '/main',
                            arguments: 3,
                          );
                        }
                      },
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/images/profile_avatar.jpg',
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Flexible(
                                      child: Text(
                                        'Hello, Albert ',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '👋',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Let's choose your next journey",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Notification Bell Button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showNotificationsSheet,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: AppTheme.textDark,
                            size: 22,
                          ),
                          if (_unreadNotifications > 0)
                            Positioned(
                              top: 10,
                              right: 12,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppTheme.discountRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Main Title: "Find The [Perfect] Place"
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 4,
                children: [
                  const Text(
                    'Find The',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLime,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Perfect',
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const Text(
                    'Place',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Bar with Voice Tap
              CustomSearchBar(
                readOnly: true,
                onTap: () {
                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!();
                  } else {
                    Navigator.of(context).pushNamed('/search');
                  }
                },
                onMicTap: _showVoiceSearchDialog,
              ),

              const SizedBox(height: 20),

              // Category Pills Horizontal Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                clipBehavior: Clip.none,
                child: Row(
                  children: List.generate(
                    _categories.length,
                    (index) {
                      final category = _categories[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == _categories.length - 1 ? 0 : 10,
                        ),
                        child: CategoryChip(
                          label: category['label'],
                          icon: category['icon'],
                          isSelected: _selectedCategoryIndex == index,
                          onTap: () {
                            setState(() {
                              _selectedCategoryIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dynamic Category View when Flights or Rental Car is chosen
              if (_selectedCategoryIndex == 1) ...[
                // Flights Section Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.flight_takeoff_rounded,
                                  color: AppTheme.darkNavy),
                              SizedBox(width: 8),
                              Text(
                                'Flights to Bali (DPS)',
                                style: TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLime,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Direct',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Non-stop airline routes with complimentary luggage allowance.',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'From ₹4,500 / person',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.darkNavy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Direct flights searched! 14 routes available.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('View Flights'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (_selectedCategoryIndex == 2) ...[
                // Rental Car Section Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.directions_car_rounded,
                                  color: AppTheme.darkNavy),
                              SizedBox(width: 8),
                              Text(
                                'SUV & Convertibles',
                                style: TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLime,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Insured',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Unlimited mileage with flexible airport pick-up & drop-off.',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'From ₹1,200 / day',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.darkNavy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Car rentals available at airport pickup.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: const Text('Book Car'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Recommended Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Recommended',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.onSearchTap != null) {
                        widget.onSearchTap!();
                      } else {
                        Navigator.of(context).pushNamed('/search');
                      }
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Large Bali Exotica Hotel Card
              HotelCard(
                hotel: MockData.baliExotica,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/hotel_details',
                    arguments: MockData.baliExotica,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Flash Deals Section Header with Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Flash Deals',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Red Countdown Badge
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showFlashDealInfo,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.discountRed,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 13,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '02 : 45 : 30',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Flash Deals Horizontal List
              SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: MockData.flashDeals.length,
                  itemBuilder: (context, index) {
                    final deal = MockData.flashDeals[index];
                    return FlashDealCard(
                      hotel: deal,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/hotel_details',
                          arguments: deal,
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 90), // Space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
