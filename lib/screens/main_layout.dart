import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home/home_screen.dart';
import 'trucks/trucks_screen.dart';
import 'bookings/bookings_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/login_screen.dart';
import '../services/auth_service.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  const MainLayout({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  String? _userName;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      setState(() => _isLoggedIn = true);
      _fetchProfile();
    }
  }

  void _fetchProfile() async {
    try {
      final res = await AuthService.getProfile();
      if (res['success'] && res['data'] != null && mounted) {
        setState(() {
          _userName = res['data']['name'];
        });
      }
    } catch (e) {
      // ignore
    }
  }

  void _logout() async {
    try {
      await AuthService.logout();
    } catch (e) {
      // ignore API errors and force local logout
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(onNavigateToTrucks: () => setState(() => _currentIndex = 1));
      case 1:
        return const TrucksScreen();
      case 2:
        return BookingsScreen(onNavigateToTrucks: () => setState(() => _currentIndex = 1));
      case 3:
        return const AboutScreen();
      case 4:
        return const ContactScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
          onTap: () => setState(() => _currentIndex = 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('TRUCK BOOKING', style: GoogleFonts.poppins(color: Colors.lightBlue, fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1.5)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: isDesktop ? [
          _buildNavButton('Beranda', 0),
          _buildNavButton('Armada Truk', 1),
          if (_isLoggedIn) _buildNavButton('Booking Saya', 2),
          _buildNavButton('Tentang Kami', 3),
          _buildNavButton('Kontak', 4),
          const SizedBox(width: 24),
          if (_userName != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text('Halo, $_userName', style: const TextStyle(color: Color(0xFF475569), fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          if (_isLoggedIn)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), elevation: 0),
                child: const Text('KELUAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, elevation: 0),
                child: const Text('MASUK / DAFTAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
        ] : [
          if (_isLoggedIn)
            IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: _logout)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('MASUK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            )
        ],
      ),
      drawer: isDesktop ? null : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF0F172A)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('TRUCK BOOKING', style: GoogleFonts.poppins(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 20)),
                  if (_isLoggedIn && _userName != null) ...
                    [
                      const SizedBox(height: 8),
                      Text('Halo, $_userName', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    ]
                  else if (!_isLoggedIn) ...
                    [
                      const SizedBox(height: 8),
                      const Text('Belum login', style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ]
                ],
              ),
            ),
            _buildDrawerItem('Beranda', 0),
            _buildDrawerItem('Armada Truk', 1),
            if (_isLoggedIn) _buildDrawerItem('Booking Saya', 2),
            _buildDrawerItem('Tentang Kami', 3),
            _buildDrawerItem('Kontak', 4),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildScreen()),
          // FOOTER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            color: const Color(0xFF0F172A), // slate-900
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TRUCK BOOKING', style: GoogleFonts.poppins(color: Colors.lightBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    const Text('Platform logistik sewa truk daring modern dan tepercaya.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
                const Text('© 2026 Truck Booking System. All rights reserved.', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, int index) {
    final isSelected = _currentIndex == index;
    return TextButton(
      onPressed: () => setState(() => _currentIndex = index),
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? Colors.lightBlue : const Color(0xFF475569),
        textStyle: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500),
      ),
      child: Text(title),
    );
  }

  Widget _buildDrawerItem(String title, int index) {
    return ListTile(
      title: Text(title, style: TextStyle(color: _currentIndex == index ? Colors.lightBlue : Colors.black87, fontWeight: _currentIndex == index ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
