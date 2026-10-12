import 'package:flutter/material.dart';
import '../models/hotel_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../data/mock_data.dart';

class BookingScreen extends StatefulWidget {
  final Hotel? hotel;

  const BookingScreen({super.key, this.hotel});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late Hotel _hotel;
  int _selectedRoomIndex = 0;

  DateTime _checkInDate = DateTime(2026, 5, 20);
  DateTime _checkOutDate = DateTime(2026, 5, 25);

  int _adultsCount = 2;
  int _childrenCount = 1;
  int _roomCount = 1;

  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Deluxe Room',
      'priceMultiplier': 1.0,
      'features': '🛏️ 1 King Bed  •  👥 2 Guests  •  📐 32 m²',
      'image': 'assets/images/hotel_room.jpg',
    },
    {
      'name': 'Ocean Premier Suite',
      'priceMultiplier': 1.45,
      'features': '🌊 Ocean View Balcony  •  🍾 Complimentary Wine  •  📐 48 m²',
      'image': 'assets/images/beach_dest.jpg',
    },
    {
      'name': 'Executive Pool Villa',
      'priceMultiplier': 1.9,
      'features': '🏊 Private Plunge Pool  •  ⭐ Butler Service  •  📐 75 m²',
      'image': 'assets/images/bali_exotica.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel ?? MockData.baliExotica;
  }

  int get _numberOfNights {
    final diff = _checkOutDate.difference(_checkInDate).inDays;
    return diff > 0 ? diff : 1;
  }

  double get _currentRoomNightlyRate {
    final multiplier = _rooms[_selectedRoomIndex]['priceMultiplier'] as double;
    return _hotel.pricePerNight * multiplier;
  }

  double get _subtotal {
    return _currentRoomNightlyRate * _numberOfNights * _roomCount;
  }

  double get _taxesAndFees {
    return _subtotal * 0.12;
  }

  double get _grandTotal {
    return _subtotal + _taxesAndFees;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Future<void> _pickCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime(2026, 1, 1),
      lastDate: DateTime(2028, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.darkNavy,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (!_checkOutDate.isAfter(_checkInDate)) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _pickCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate.isAfter(_checkInDate)
          ? _checkOutDate
          : _checkInDate.add(const Duration(days: 1)),
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(2028, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.darkNavy,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  void _showGuestsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guests & Rooms',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCounterRow(
                    label: 'Adults',
                    subtitle: 'Ages 13 and above',
                    value: _adultsCount,
                    onDecrement: _adultsCount > 1
                        ? () {
                            setSheetState(() => _adultsCount--);
                            setState(() {});
                          }
                        : null,
                    onIncrement: () {
                      setSheetState(() => _adultsCount++);
                      setState(() {});
                    },
                  ),
                  const Divider(height: 24),
                  _buildCounterRow(
                    label: 'Children',
                    subtitle: 'Ages 0 - 12',
                    value: _childrenCount,
                    onDecrement: _childrenCount > 0
                        ? () {
                            setSheetState(() => _childrenCount--);
                            setState(() {});
                          }
                        : null,
                    onIncrement: () {
                      setSheetState(() => _childrenCount++);
                      setState(() {});
                    },
                  ),
                  const Divider(height: 24),
                  _buildCounterRow(
                    label: 'Rooms',
                    subtitle: 'Total rooms needed',
                    value: _roomCount,
                    onDecrement: _roomCount > 1
                        ? () {
                            setSheetState(() => _roomCount--);
                            setState(() {});
                          }
                        : null,
                    onIncrement: () {
                      setSheetState(() => _roomCount++);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Apply',
                    height: 50,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow({
    required String label,
    required String subtitle,
    required int value,
    required VoidCallback? onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: onDecrement == null ? Colors.grey.shade300 : AppTheme.darkNavy,
            ),
            Text(
              '$value',
              style: const TextStyle(
                color: AppTheme.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: AppTheme.darkNavy,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
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
        ),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Snippet Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          _hotel.imagePath,
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hotel.name,
                              style: const TextStyle(
                                color: AppTheme.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _hotel.country,
                              style: const TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppTheme.starGold,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${_hotel.rating}',
                            style: const TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Interactive Booking Dates & Guests
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _pickCheckInDate,
                        borderRadius: BorderRadius.circular(12),
                        child: _buildDetailRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'Check-in',
                          value: _formatDate(_checkInDate),
                          isEditable: true,
                        ),
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      InkWell(
                        onTap: _pickCheckOutDate,
                        borderRadius: BorderRadius.circular(12),
                        child: _buildDetailRow(
                          icon: Icons.calendar_month_rounded,
                          label: 'Check-out',
                          value: _formatDate(_checkOutDate),
                          isEditable: true,
                        ),
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      InkWell(
                        onTap: _showGuestsSheet,
                        borderRadius: BorderRadius.circular(12),
                        child: _buildDetailRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Guests & Rooms',
                          value:
                              '$_adultsCount Adults, $_childrenCount Child ($_roomCount ${_roomCount > 1 ? "Rooms" : "Room"})',
                          isEditable: true,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Select Room Header
                const Text(
                  'Select Room Category',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Dynamic Room Cards
                ...List.generate(_rooms.length, (index) {
                  final room = _rooms[index];
                  final isSelected = _selectedRoomIndex == index;
                  final roomRate =
                      (_hotel.pricePerNight * (room['priceMultiplier'] as double))
                          .round();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _selectedRoomIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLimeDark
                                : Colors.grey.shade200,
                            width: 2,
                          ),
                          boxShadow: AppTheme.cardShadow,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                room['image'] as String,
                                width: 78,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        room['name'] as String,
                                        style: const TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected
                                              ? AppTheme.primaryLime
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppTheme.primaryLimeDark
                                                : Colors.grey.shade400,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Center(
                                                child: Icon(
                                                  Icons.check_rounded,
                                                  size: 13,
                                                  color: AppTheme.darkNavy,
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '\$$roomRate',
                                        style: const TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Text(
                                        ' / night',
                                        style: TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    room['features'] as String,
                                    style: const TextStyle(
                                      color: AppTheme.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Price Summary Section
                const Text(
                  'Price Summary',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow(
                        'Room Price ($_numberOfNights nights x $_roomCount room)',
                        '\$${_subtotal.round()}',
                      ),
                      const SizedBox(height: 10),
                      _buildPriceRow(
                        'Taxes & Service Fees (12%)',
                        '\$${_taxesAndFees.round()}',
                      ),
                      const Divider(height: 24, thickness: 0.8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: AppTheme.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '\$${_grandTotal.round()}',
                            style: const TextStyle(
                              color: Color(0xFF7CB800),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // Fixed Bottom Bar with Proceed to Pay Button
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
                  text: 'Proceed to Pay • \$${_grandTotal.round()}',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/confirmation',
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

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isEditable = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.textMuted),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.edit_calendar_rounded,
                  size: 15,
                  color: AppTheme.textLight,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
