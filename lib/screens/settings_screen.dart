import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/theme_mode_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: const Text('Dark Mode'),
                  trailing: CupertinoSwitch(
                    value: themeProvider.isDark,
                    onChanged: themeProvider.setDarkMode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
