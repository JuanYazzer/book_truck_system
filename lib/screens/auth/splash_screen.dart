import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_layout.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _dotController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _taglineFade;
  late Animation<double> _dotFade;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _logoFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoScale = Tween<double>(begin: 0.6, end: 1).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    // Text animation
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _textFade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Tagline animation
    _taglineController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _taglineFade = Tween<double>(begin: 0, end: 1).animate(_taglineController);

    // Dot (loading) animation
    _dotController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _dotFade = Tween<double>(begin: 0, end: 1).animate(_dotController);

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _dotController.forward();

    // Check auth while animations play
    await Future.delayed(const Duration(milliseconds: 1200));
    _navigate();
  }

  void _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(context, _fadeRoute(const MainLayout()));
      return;
    }

    final role = prefs.getString('user_role') ?? 'user';
    final name = prefs.getString('user_name') ?? '';

    if (role == 'admin') {
      await prefs.clear();
      if (!mounted) return;
      Navigator.pushReplacement(context, _fadeRoute(const LoginScreen()));
    } else {
      Navigator.pushReplacement(context, _fadeRoute(const MainLayout()));
    }
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // slate-900, same as footer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TRUCK ICON with animation
            ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoFade,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1.5),
                  ),
                  child: const Center(
                    child: Text('🚚', style: TextStyle(fontSize: 52)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // BRAND NAME
            SlideTransition(
              position: _textSlide,
              child: FadeTransition(
                opacity: _textFade,
                child: Text(
                  'TRUCK BOOKING',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF38BDF8),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // TAGLINE
            FadeTransition(
              opacity: _taglineFade,
              child: const Text(
                'Platform Logistik Sewa Truk Modern',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // LOADING DOTS
            FadeTransition(
              opacity: _dotFade,
              child: const _PulsingDots(),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated pulsing dots indicator
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) => AnimationController(vsync: this, duration: const Duration(milliseconds: 600)));
    _animations = _controllers.map((c) => Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: c, curve: Curves.easeInOut))).toList();

    _startPulse();
  }

  void _startPulse() async {
    while (mounted) {
      for (int i = 0; i < 3; i++) {
        if (!mounted) break;
        final controller = _controllers[i];
        controller.forward().then((_) => controller.reverse());
        await Future.delayed(const Duration(milliseconds: 180));
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FadeTransition(
          opacity: _animations[i],
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF38BDF8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      )),
    );
  }
}
