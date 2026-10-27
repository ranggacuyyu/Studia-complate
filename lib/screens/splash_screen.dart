import 'package:flutter/material.dart';
import '../widgets/app_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  late AnimationController _textController;
  late Animation<double> _textScaleAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Animasi Logo (Muncul cepat & halus - 500ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _logoFadeAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );
    _logoScaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // 2. Animasi Teks (550ms)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _textScaleAnimation = Tween<double>(begin: 1.15, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Jalankan urutan setelah frame pertama siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationSequence();
    });
  }

  Future<void> _startAnimationSequence() async {
    // Pastikan gambar logo sudah siap di memory sebelum animasi dimulai
    try {
      await AppLogo.precache(context);
    } catch (_) {}

    if (!mounted) return;

    // Jalankan animasi logo
    _logoController.forward();

    // Teks menyusul cepat (stagger 150ms agar dinamis)
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    _textController.forward();

    // Waktu tampil yang pas (tidak terlalu lama agar tidak terasa membosankan/stuck)
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A34),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO: Fade in + Scale halus
            FadeTransition(
              opacity: _logoFadeAnimation,
              child: ScaleTransition(
                scale: _logoScaleAnimation,
                child: const AppLogo(
                  size: 110,
                  shadowOpacity: 0.35,
                  showBorder: true,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // TEKS BRANDING
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Opacity(
                  opacity: _textRevealAnimation.value > 0.05 ? 1.0 : 0.0,
                  child: Transform.scale(
                    scale: _textScaleAnimation.value,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _textRevealAnimation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  const Text(
                    'Studia',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Catatan & Pengingat Agenda Kuliah',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
