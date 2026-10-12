import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/hotel_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../data/mock_data.dart';

class ConfirmationScreen extends StatefulWidget {
  final Hotel? hotel;

  const ConfirmationScreen({super.key, this.hotel});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late Hotel _hotel;
  late AnimationController _checkController;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _hotel = widget.hotel ?? MockData.baliExotica;

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _checkController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  void _showTicketModal() {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Electronic Ticket',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.bgLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _hotel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const Text(
                            'PAID',
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _hotel.location,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const Divider(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Guest: Albert M.',
                              style: TextStyle(fontSize: 13)),
                          Text('Room: 1 x Deluxe',
                              style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Barcode simulation
                      Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            28,
                            (index) => Container(
                              width: (index % 3 == 0) ? 3 : 1.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Save E-Ticket to Device',
                  height: 48,
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('E-Ticket downloaded to files!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bookingId = '#TE123456789';

    return Scaffold(
      body: Stack(
        children: [
          // Celebration Dots Graphic Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: CustomPaint(
              painter: CelebrationSparksPainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Animated Success Checkmark Badge
                ScaleTransition(
                  scale: _checkScale,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLime,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryLime.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppTheme.darkNavy,
                      size: 44,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Your trip to ${_hotel.name} is all set.\nGet ready for an amazing journey!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Booking ID Container
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking ID',
                                style: TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    bookingId,
                                    style: TextStyle(
                                      color: AppTheme.textDark,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Clipboard.setData(
                                          const ClipboardData(text: bookingId));
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Booking ID copied to clipboard!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.bgLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.copy_rounded,
                                        color: AppTheme.textDark,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Hotel & Dates Summary Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            children: [
                              // Hotel Item
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      _hotel.imagePath,
                                      width: 54,
                                      height: 54,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _hotel.name,
                                        style: const TextStyle(
                                          color: AppTheme.textDark,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _hotel.country,
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 28, thickness: 0.8),

                              _buildSummaryRow(
                                icon: Icons.calendar_today_rounded,
                                label: 'Check-in',
                                value: '20 May, 2026',
                              ),
                              const SizedBox(height: 12),
                              _buildSummaryRow(
                                icon: Icons.calendar_month_rounded,
                                label: 'Check-out',
                                value: '25 May, 2026',
                              ),
                              const SizedBox(height: 12),
                              _buildSummaryRow(
                                icon: Icons.person_outline_rounded,
                                label: 'Guests',
                                value: '2 Adults, 1 Child',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Action Buttons Row: View Ticket & Add to Calendar
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                onPressed: _showTicketModal,
                                icon: const Icon(
                                  Icons.receipt_long_rounded,
                                  color: AppTheme.darkNavy,
                                  size: 18,
                                ),
                                label: const Text(
                                  'View Ticket',
                                  style: TextStyle(
                                    color: AppTheme.darkNavy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Trip added to calendar with check-in reminder!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: AppTheme.darkNavy,
                                  size: 18,
                                ),
                                label: const Text(
                                  'Add Calendar',
                                  style: TextStyle(
                                    color: AppTheme.darkNavy,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button: Back to Home
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(
                    text: 'Back to Home',
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/main',
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.textMuted),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Celebration Sparks Background Painter
class CelebrationSparksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 =
        Paint()..color = const Color(0xFFC6F52B).withValues(alpha: 0.4);
    final paint2 =
        Paint()..color = const Color(0xFF38BDF8).withValues(alpha: 0.3);
    final paint3 =
        Paint()..color = const Color(0xFFF472B6).withValues(alpha: 0.3);

    final List<Offset> points1 = [
      Offset(size.width * 0.15, size.height * 0.3),
      Offset(size.width * 0.82, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.6),
    ];

    final List<Offset> points2 = [
      Offset(size.width * 0.2, size.height * 0.15),
      Offset(size.width * 0.75, size.height * 0.45),
      Offset(size.width * 0.88, size.height * 0.7),
    ];

    final List<Offset> points3 = [
      Offset(size.width * 0.45, size.height * 0.1),
      Offset(size.width * 0.65, size.height * 0.65),
    ];

    for (var p in points1) {
      canvas.drawCircle(p, 5, paint1);
    }
    for (var p in points2) {
      canvas.drawCircle(p, 4, paint2);
    }
    for (var p in points3) {
      canvas.drawCircle(p, 3, paint3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
