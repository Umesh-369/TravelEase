import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/hotel_card.dart';
import '../data/mock_data.dart';
import '../models/hotel_model.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const SearchScreen({super.key, this.onBackToHome});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  RangeValues _priceRange = const RangeValues(1000, 6000);
  int _selectedRatingIndex = 0;
  bool _distanceSwitch = true;
  String _selectedDistance = 'Any Distance';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All Stays', 'icon': Icons.explore_rounded},
    {'label': 'Beach', 'icon': Icons.beach_access_rounded},
    {'label': 'Mountain', 'icon': Icons.landscape_rounded},
    {'label': 'Luxury', 'icon': Icons.diamond_outlined},
  ];

  final List<String> _ratings = ['All', '4+ ★', '4.5+ ★', '5+ ★'];

  final List<Map<String, dynamic>> _facilities = [
    {'label': 'Pool', 'icon': Icons.pool_rounded},
    {'label': 'Wifi', 'icon': Icons.wifi_rounded},
    {'label': 'Ocean View', 'icon': Icons.waves_rounded},
    {'label': 'Breakfast', 'icon': Icons.free_breakfast_rounded},
    {'label': 'Spa', 'icon': Icons.spa_rounded},
  ];

  final Set<String> _selectedFacilities = {'Pool', 'Wifi'};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategoryIndex = 0;
      _priceRange = const RangeValues(1000, 6000);
      _selectedRatingIndex = 0;
      _distanceSwitch = true;
      _selectedDistance = 'Any Distance';
      _selectedFacilities.clear();
      _selectedFacilities.addAll(['Pool', 'Wifi']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filters reset to default'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  List<Hotel> _getFilteredHotels() {
    final allHotels = [
      ...MockData.recommendedHotels,
      ...MockData.flashDeals,
    ];

    return allHotels.where((hotel) {
      // Query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = hotel.name.toLowerCase().contains(query);
        final matchesLoc = hotel.location.toLowerCase().contains(query);
        final matchesCountry = hotel.country.toLowerCase().contains(query);
        if (!matchesName && !matchesLoc && !matchesCountry) return false;
      }

      // Price filter
      if (hotel.pricePerNight < _priceRange.start ||
          hotel.pricePerNight > _priceRange.end) {
        return false;
      }

      // Rating filter
      if (_selectedRatingIndex == 1 && hotel.rating < 4.0) return false;
      if (_selectedRatingIndex == 2 && hotel.rating < 4.5) return false;
      if (_selectedRatingIndex == 3 && hotel.rating < 5.0) return false;

      // Category filter
      if (_selectedCategoryIndex == 1 &&
          !hotel.description.toLowerCase().contains('beach') &&
          !hotel.name.toLowerCase().contains('sunset')) {
        return false;
      }
      if (_selectedCategoryIndex == 2 &&
          !hotel.description.toLowerCase().contains('mountain') &&
          !hotel.name.toLowerCase().contains('alpine')) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showResultsBottomSheet(List<Hotel> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
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
                  Text(
                    '${results.length} Available Places',
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: results.isEmpty
                    ? const Center(
                        child: Text(
                          'No places match these filters.\nTry broadening your search!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final h = results[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: HotelCard(
                              hotel: h,
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.of(context).pushNamed(
                                  '/hotel_details',
                                  arguments: h,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredHotels = _getFilteredHotels();

    return Scaffold(
      body: Stack(
        children: [
          // Background soft blue mountain illustration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: CustomPaint(
              painter: HeaderMountainPainter(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Top bar with Back Button and Reset button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else if (widget.onBackToHome != null) {
                            widget.onBackToHome!();
                          }
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Reset'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textMuted,
                          backgroundColor: Colors.white.withValues(alpha: 0.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Heading
                  const Text(
                    'Search Destinations',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find your perfect getaway',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Search Field with Live Filter
                  CustomSearchBar(
                    controller: _searchController,
                    hintText: 'Search destinations, hotels...',
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    onClear: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Category Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    clipBehavior: Clip.none,
                    child: Row(
                      children: List.generate(_categories.length, (index) {
                        final item = _categories[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _categories.length - 1 ? 0 : 8,
                          ),
                          child: CategoryChip(
                            label: item['label'],
                            icon: item['icon'],
                            isSelected: _selectedCategoryIndex == index,
                            onTap: () {
                              setState(() {
                                _selectedCategoryIndex = index;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Price Range Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.primaryLime,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: AppTheme.primaryLimeDark,
                      overlayColor: AppTheme.primaryLime.withValues(alpha: 0.2),
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 4,
                      ),
                    ),
                    child: RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 10000,
                      onChanged: (values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹0',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '₹10,000+',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Rating Filter Section
                  const Text(
                    'Rating',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(_ratings.length, (index) {
                      final isSelected = _selectedRatingIndex == index;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => _selectedRatingIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.darkNavy
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.darkNavy
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Text(
                            _ratings[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Facilities Section
                  const Text(
                    'Facilities',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _facilities.map((fac) {
                        final label = fac['label'] as String;
                        final icon = fac['icon'] as IconData;
                        final isSelected =
                            _selectedFacilities.contains(label);

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFacilities.remove(label);
                              } else {
                                _selectedFacilities.add(label);
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryLime.withValues(alpha: 0.25)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryLimeDark
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 20,
                                  color: AppTheme.textDark,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  label,
                                  style: const TextStyle(
                                    color: AppTheme.textDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Distance Section with Dropdown & Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: _selectedDistance,
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: AppTheme.textMuted,
                            ),
                            items: ['Any Distance', '< 5 km', '< 10 km']
                                .map((val) => DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedDistance = val);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _distanceSwitch,
                            activeThumbColor: AppTheme.primaryLime,
                            activeTrackColor:
                                AppTheme.primaryLime.withValues(alpha: 0.5),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey.shade300,
                            onChanged: (val) {
                              setState(() => _distanceSwitch = val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Dynamic "Show X Places" Button
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _showResultsBottomSheet(filteredHotels);
                    },
                    child: Container(
                      height: 58,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.darkNavy,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.darkNavy.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryLime,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.tune_rounded,
                              color: AppTheme.darkNavy,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Show ${filteredHotels.length} Places',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 52),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Space for bottom navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for subtle background mountain decoration graphic
class HeaderMountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE2F1F8).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFFD6EBF5).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final path1 = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.75, 120)
      ..lineTo(size.width, 40)
      ..lineTo(size.width, 0)
      ..close();

    final path2 = Path()
      ..moveTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.85, 140)
      ..lineTo(size.width, 90)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
