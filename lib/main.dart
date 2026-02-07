import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';

import 'providers/tasks_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tasks_screen.dart';
import 'widgets/glass_panel.dart';

void main() {
  runApp(const CalendarTaskApp());
}

class CalendarTaskApp extends StatelessWidget {
  const CalendarTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
      ],
      child: Consumer<ThemeModeProvider>(
        builder: (context, themeProvider, _) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
              brightness: themeProvider.isDark
                  ? Brightness.dark
                  : Brightness.light,
              primaryColor: CupertinoColors.systemBlue,
              scaffoldBackgroundColor: CupertinoColors.systemBackground,
            ),
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  static const double _tabBarHeight = 60;

  final List<Widget> _screens = const [
    HomeScreen(),
    TasksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: _tabBarHeight + bottomInset + 16),
            child: IndexedStack(index: _currentIndex, children: _screens),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 12 + bottomInset,
            child: _GlassTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTabBar extends StatelessWidget {
  const _GlassTabBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final Color pillBorder = CupertinoDynamicColor.withBrightness(
      color: const Color(0x3DFFFFFF),
      darkColor: const Color(0x33FFFFFF),
    ).resolveFrom(context);
    final Color pillFill = CupertinoDynamicColor.withBrightness(
      color: const Color(0x1FFFFFFF),
      darkColor: const Color(0x1FFFFFFF),
    ).resolveFrom(context);

    return GlassPanel(
      radius: 26,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: SizedBox(
        height: _MainShellState._tabBarHeight - 12,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / 3;
            final pillLeft = itemWidth * currentIndex + 4;

            return _PressScale(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  final dx = details.localPosition.dx.clamp(
                    0.0,
                    constraints.maxWidth,
                  );
                  final index = (dx / itemWidth).floor().clamp(0, 2);
                  if (index != currentIndex) {
                    onTap(index);
                  }
                },
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      left: pillLeft,
                      top: 4,
                      bottom: 4,
                      width: itemWidth - 8,
                      child: LiquidGlass.withOwnLayer(
                        settings: const LiquidGlassSettings(
                          thickness: 20,
                          blur: 14,
                          glassColor: Color(0x3AFFFFFF),
                          lightIntensity: 1.2,
                          saturation: 1.15,
                        ),
                        shape: LiquidRoundedSuperellipse(borderRadius: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: pillBorder, width: 0.8),
                            color: pillFill,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _TabItem(
                          icon: CupertinoIcons.calendar,
                          label: 'Home',
                          isActive: currentIndex == 0,
                          onTap: () => onTap(0),
                        ),
                        _TabItem(
                          icon: CupertinoIcons.checkmark_circle,
                          label: 'Tasks',
                          isActive: currentIndex == 1,
                          onTap: () => onTap(1),
                        ),
                        _TabItem(
                          icon: CupertinoIcons.settings,
                          label: 'Settings',
                          isActive: currentIndex == 2,
                          onTap: () => onTap(2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PressScale extends StatefulWidget {
  const _PressScale({required this.child});

  final Widget child;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },
      onLongPressStart: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _pressed = false;
        });
      },
      child: AnimatedScale(
        scale: _pressed ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = CupertinoColors.activeBlue.resolveFrom(context);
    final Color inactiveColor = CupertinoColors.secondaryLabel.resolveFrom(
      context,
    );

    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeColor : inactiveColor),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
