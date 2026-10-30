import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../data/mock_data.dart';

class HotelDetailsScreen extends StatefulWidget {
  final Hotel? hotel;

  const HotelDetailsScreen({super.key, this.hotel});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  late Hotel _hotel;
  late bool _isFavorite;
  int _currentPhotoIndex = 0;

  final List<String> _galleryImages = [
    'assets/images/bali_exotica.jpg',
    'assets/images/hotel_room.jpg',
    'assets/images/beach_dest.jpg',
    'assets/images/flash_deal_hotel.jpg',
    'assets/images/mountain_dest.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel ?? MockData.baliExotica;
    _isFavorite = _hotel.isFavorite;
    // ensure first image matches current hotel image if present
    if (!_galleryImages.contains(_hotel.imagePath)) {
      _galleryImages[0] = _hotel.imagePath;
    }
  }

  final List<Map<String, dynamic>> _facilityItems = [
    {
      'label': 'Pool',
      'icon': Icons.pool_rounded,
      'info': 'Infinity pool open 24/7 with heated water & sunset view.',
    },
    {
      'label': 'Wifi',
      'icon': Icons.wifi_rounded,
      'info': 'Ultra-fast fiber optic internet throughout the resort.',
    },
    {
      'label': 'Ocean View',
      'icon': Icons.waves_rounded,
      'info': 'Unobstructed 180° views of the turquoise ocean waters.',
    },
    {
      'label': 'Breakfast',
      'icon': Icons.free_breakfast_rounded,
      'info': 'Complimentary gourmet buffet breakfast every morning.',
    },
    {
      'label': 'Spa',
      'icon': Icons.spa_rounded,
      'info': 'Organic Balinese massage and full wellness center.',
    },
    {
      'label': 'Gym',
      'icon': Icons.fitness_center_rounded,
      'info': 'Fully equipped fitness center with cardio & weights.',
    },
    {
      'label': 'Parking',
      'icon': Icons.local_parking_rounded,
      'info': 'Free valet parking with 24-hour security.',
    },
    {
      'label': 'Restaurant',
      'icon': Icons.restaurant_rounded,
      'info': 'Fine-dining seafood & international Michelin-rated chefs.',
    },
  ];

  void _cycleNextPhoto() {
    setState(() {
      _currentPhotoIndex = (_currentPhotoIndex + 1) % _galleryImages.length;
    });
  }

  void _showFacilityDetail(String title, String info) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLime,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Included',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                info,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Got it',
                height: 48,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero Image and Content Scrollable
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Top Hero Image Stack
                Stack(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _cycleNextPhoto,
                      child: SizedBox(
                        height: 340,
                        width: double.infinity,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset(
                            _galleryImages[_currentPhotoIndex],
                            key: ValueKey<int>(_currentPhotoIndex),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 340,
                          ),
                        ),
                      ),
                    ),

                    // Top Bar Buttons
                    Positioned(
                      top: 50,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                _isFavorite = !_isFavorite;
                              });
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _isFavorite
                                        ? 'Saved ${_hotel.name} to favorites!'
                                        : 'Removed from favorites',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 20,
                                color: _isFavorite
                                    ? AppTheme.discountRed
                                    : AppTheme.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Right Image Counter Badge "X/5"
                    Positioned(
                      bottom: 40,
                      right: 20,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _cycleNextPhoto,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_currentPhotoIndex + 1}/${_galleryImages.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Details Content Sheet
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title & Rating Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _hotel.name,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: AppTheme.textMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _hotel.location,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Rating Badge
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppTheme.starGold,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_hotel.rating}',
                                  style: const TextStyle(
                                    color: AppTheme.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  ' (${(_hotel.reviewCount / 1000).toStringAsFixed(1)}k reviews)',
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '₹${_hotel.pricePerNight.toInt()}',
                              style: const TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              ' / night',
                              style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // About This Place
                        const Text(
                          'About this place',
                          style: TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hotel.description,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Facilities Grid (Interactive)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Facilities',
                              style: TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Tap for details',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _facilityItems.length,
                          itemBuilder: (context, index) {
                            final item = _facilityItems[index];
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _showFacilityDetail(
                                item['label'] as String,
                                item['info'] as String,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppTheme.bgLight,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Icon(
                                      item['icon'] as IconData,
                                      color: AppTheme.textDark,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['label'] as String,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Fixed Bottom Bar with Book Now Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: CustomButton(
                  text: 'Book Now',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/booking',
                      arguments: _hotel,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
