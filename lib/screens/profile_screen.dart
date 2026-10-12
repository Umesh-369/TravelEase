import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'search_screen.dart'; // Uses HeaderMountainPainter

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onFavoritesTap;

  const ProfileScreen({super.key, this.onFavoritesTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Albert';
  String _userEmail = 'albert@example.com';
  String _userPhone = '+1 (555) 234-5678';
  bool _pushNotifications = true;
  bool _emailOffers = false;
  bool _biometricLogin = true;
  String _selectedCurrency = 'USD (\$)';

  void _showSettingsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
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
                  const Text(
                    'App Settings',
                    style: TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Push Notifications',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Booking updates & deal alerts'),
                    value: _pushNotifications,
                    activeThumbColor: AppTheme.primaryLime,
                    activeTrackColor:
                        AppTheme.primaryLime.withValues(alpha: 0.5),
                    onChanged: (val) {
                      setModalState(() => _pushNotifications = val);
                      setState(() => _pushNotifications = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Email Offers & News',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle:
                        const Text('Weekly travel deals & secret discounts'),
                    value: _emailOffers,
                    activeThumbColor: AppTheme.primaryLime,
                    activeTrackColor:
                        AppTheme.primaryLime.withValues(alpha: 0.5),
                    onChanged: (val) {
                      setModalState(() => _emailOffers = val);
                      setState(() => _emailOffers = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Biometric Security',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Face ID / Touch ID at login'),
                    value: _biometricLogin,
                    activeThumbColor: AppTheme.primaryLime,
                    activeTrackColor:
                        AppTheme.primaryLime.withValues(alpha: 0.5),
                    onChanged: (val) {
                      setModalState(() => _biometricLogin = val);
                      setState(() => _biometricLogin = val);
                    },
                  ),
                  ListTile(
                    title: const Text('Currency',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: DropdownButton<String>(
                      value: _selectedCurrency,
                      underline: const SizedBox(),
                      items: ['USD (\$)', 'EUR (€)', 'GBP (£)', 'AUD (\$)']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => _selectedCurrency = val);
                          setState(() => _selectedCurrency = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Done',
                    height: 48,
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

  void _showMyBookingsModal() {
    final bookings = [
      {
        'title': 'Bali Exotica Resort',
        'dates': '20 May - 25 May, 2026',
        'status': 'Confirmed',
        'id': '#TE123456789',
        'price': '\$1,320',
      },
      {
        'title': 'Alpine Crest Villa',
        'dates': '12 Jan - 16 Jan, 2026',
        'status': 'Completed',
        'id': '#TE987654321',
        'price': '\$1,240',
      },
      {
        'title': 'Sunset Ocean Resort',
        'dates': '05 Nov - 09 Nov, 2025',
        'status': 'Completed',
        'id': '#TE555444333',
        'price': '\$1,120',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
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
              const Text(
                'My Bookings',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final item = bookings[index];
                    final isConfirmed = item['status'] == 'Confirmed';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.bgLight,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isConfirmed
                                      ? AppTheme.primaryLime
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  item['status']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isConfirmed
                                        ? AppTheme.darkNavy
                                        : AppTheme.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['dates']!,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['id']!,
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                item['price']!,
                                style: const TextStyle(
                                  color: AppTheme.textDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
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

  void _showPersonalInfoModal() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
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
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Save Changes',
                  height: 50,
                  onPressed: () {
                    setState(() {
                      _userName = nameController.text.trim();
                      _userEmail = emailController.text.trim();
                      _userPhone = phoneController.text.trim();
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile details updated successfully!'),
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

  void _showPaymentMethodsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
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
              const Text(
                'Payment Methods',
                style: TextStyle(
                  color: AppTheme.textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.bgLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.credit_card_rounded,
                        color: AppTheme.darkNavy, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Visa ending in •••• 4242',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          Text('Expires 08/28  •  Default',
                              style: TextStyle(
                                  color: AppTheme.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.check_circle_rounded,
                        color: Color(0xFF16A34A), size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add card flow opened'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add New Card or PayPal'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReviewsModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.star_rounded, color: AppTheme.starGold),
              SizedBox(width: 8),
              Text('User Rating 4.8 / 5.0'),
            ],
          ),
          content: const Text(
            'You are a Verified Elite Traveler on TravelEase.\nYou have submitted 12 verified reviews across 3 continents with 98% positive helpful votes.',
            style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out of TravelEase?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.discountRed,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mountain Header Graphics
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
                children: [
                  const SizedBox(height: 8),

                  // Top Gear / Settings Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _showSettingsModal,
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
                            Icons.settings_outlined,
                            size: 20,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // User Avatar & Name
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Change profile picture'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x10000000),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.asset(
                                    'assets/images/profile_avatar.jpg',
                                    width: 76,
                                    height: 76,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryLime,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    size: 14,
                                    color: AppTheme.darkNavy,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _userName,
                          style: const TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail,
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Row Card (Interactive)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('3', 'Bookings', _showMyBookingsModal),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        _buildStatColumn('2', 'Favorites', () {
                          if (widget.onFavoritesTap != null) {
                            widget.onFavoritesTap!();
                          }
                        }),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey.shade200,
                        ),
                        _buildStatColumn('4.8', 'Rating', _showReviewsModal),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Profile Menu List Items Card (All Working!)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.calendar_today_rounded,
                          title: 'My Bookings',
                          onTap: _showMyBookingsModal,
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.favorite_border_rounded,
                          title: 'Favorites',
                          onTap: () {
                            if (widget.onFavoritesTap != null) {
                              widget.onFavoritesTap!();
                            }
                          },
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          onTap: _showPersonalInfoModal,
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Payment Methods',
                          onTap: _showPaymentMethodsModal,
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          onTap: _showSettingsModal,
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Settings',
                          onTap: _showSettingsModal,
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          iconColor: AppTheme.discountRed,
                          textColor: AppTheme.discountRed,
                          onTap: _showLogoutDialog,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 14,
                color: AppTheme.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(
          icon,
          color: iconColor ?? AppTheme.textDark,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? AppTheme.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.textMuted,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.8,
      indent: 20,
      endIndent: 20,
      color: Color(0xFFF1F5F9),
    );
  }
}
