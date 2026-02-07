import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/theme_mode_provider.dart';
import '../widgets/glass_background.dart';
import '../widgets/glass_panel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();

    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const Positioned.fill(child: GlassBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: GlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      GlassPanel(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: CupertinoListSection.insetGrouped(
                          backgroundColor: CupertinoColors.transparent,
                          separatorColor: CupertinoColors.separator,
                          children: [
                            CupertinoListTile(
                              backgroundColor: CupertinoColors.transparent,
                              title: const Text('Dark Mode'),
                              trailing: CupertinoSwitch(
                                value: themeProvider.isDark,
                                onChanged: themeProvider.setDarkMode,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
