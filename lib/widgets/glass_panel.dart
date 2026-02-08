import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    final bool isDark =
        CupertinoTheme.of(context).brightness == Brightness.dark;
    final bool reduceEffects =
        defaultTargetPlatform == TargetPlatform.android ||
        MediaQuery.of(context).disableAnimations;
    final Color baseTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x06FFFFFF),
      darkColor: const Color(0x12FFFFFF),
    ).resolveFrom(context);
    final Color highlightTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x16FFFFFF),
      darkColor: const Color(0x20FFFFFF),
    ).resolveFrom(context);
    final Color borderTint = CupertinoDynamicColor.withBrightness(
      color: const Color(0x1DFFFFFF),
      darkColor: const Color(0x24FFFFFF),
    ).resolveFrom(context);
    final Color darkGradientStart = const Color(0x33121F2E);
    final Color darkGradientEnd = const Color(0x1F0D141E);
    final LiquidGlassSettings glassSettings = reduceEffects
        ? const LiquidGlassSettings(
            thickness: 8,
            blur: 6,
            glassColor: Color(0x16FFFFFF),
            lightIntensity: 0.9,
            saturation: 1.0,
          )
        : const LiquidGlassSettings(
            thickness: 14,
            blur: 10,
            glassColor: Color(0x1EFFFFFF),
            lightIntensity: 1.0,
            saturation: 1.05,
          );
    return LiquidGlass.withOwnLayer(
      settings: glassSettings,
      shape: LiquidRoundedSuperellipse(borderRadius: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? const Color(0x14121F2E) : baseTint,
            border: Border.all(color: borderTint, width: 0.4),
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: isDark
                  ? [darkGradientStart, darkGradientEnd]
                  : [highlightTint, baseTint],
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
