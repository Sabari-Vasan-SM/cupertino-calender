import 'package:flutter/cupertino.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final base = CupertinoDynamicColor.withBrightness(
      color: const Color(0xFFF6F9FF),
      darkColor: const Color(0xFF050608),
    ).resolveFrom(context);
    final tint = CupertinoDynamicColor.withBrightness(
      color: const Color(0xFFEAF2FF),
      darkColor: const Color(0xFF0B0D12),
    ).resolveFrom(context);
    final glow = CupertinoDynamicColor.withBrightness(
      color: const Color(0xFFCFE1FF),
      darkColor: const Color(0xFF0A0D16),
    ).resolveFrom(context);
    final glowAlt = CupertinoDynamicColor.withBrightness(
      color: const Color(0xFFBFD6FF),
      darkColor: const Color(0xFF121622),
    ).resolveFrom(context);
    final glowMid = CupertinoDynamicColor.withBrightness(
      color: const Color(0xFFD9E7FF),
      darkColor: const Color(0xFF0C101B),
    ).resolveFrom(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [base, tint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _GlowCircle(color: glow, size: 260),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: _GlowCircle(color: glowAlt, size: 230),
          ),
          Positioned(
            top: 160,
            left: -70,
            child: _GlowCircle(color: glowMid, size: 180),
          ),
        ],
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.6), color.withOpacity(0.0)],
        ),
      ),
    );
  }
}
