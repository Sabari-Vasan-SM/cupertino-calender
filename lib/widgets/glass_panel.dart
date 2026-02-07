import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.radius = 18,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final Color baseTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x14FFFFFF),
      darkColor: const Color(0x1FFFFFFF),
    ).resolveFrom(context);
    final Color highlightTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x33FFFFFF),
      darkColor: const Color(0x2AFFFFFF),
    ).resolveFrom(context);
    final Color borderTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x3DFFFFFF),
      darkColor: const Color(0x33FFFFFF),
    ).resolveFrom(context);
    return LiquidGlass.withOwnLayer(
      settings: const LiquidGlassSettings(
        thickness: 18,
        blur: 14,
        glassColor: Color(0x2FFFFFFF),
        lightIntensity: 1.1,
        saturation: 1.15,
      ),
      shape: LiquidRoundedSuperellipse(borderRadius: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: baseTint,
            border: Border.all(color: borderTint, width: 0.6),
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [highlightTint, baseTint],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
