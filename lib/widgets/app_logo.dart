import 'package:flutter/material.dart';

/// Logo Studia yang dipakai bersama oleh Splash dan Login.
///
/// Menggunakan [Hero] sehingga logo berpindah mulus saat navigasi.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.shadowOpacity = 0.18,
    this.showBorder = false,
  });

  static const String assetPath = 'assets/images/logo.png';
  static const String heroTag = 'studia-logo';

  final double size;
  final double shadowOpacity;
  final bool showBorder;

  /// Memuat logo ke memori GPU lebih awal (pre-cache) agar tampil instan 0ms.
  static Future<void> precache(BuildContext context) =>
      precacheImage(const AssetImage(assetPath), context);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size * 0.22);

    return Hero(
      tag: heroTag,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: showBorder
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: shadowOpacity),
              blurRadius: size * 0.22,
              offset: Offset(0, size * 0.09),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Image.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            filterQuality: FilterQuality.medium,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFF1E3A34),
              child: Icon(
                Icons.menu_book_rounded,
                size: size * 0.5,
                color: const Color(0xFF95C4A1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
