import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_mode_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeModeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDark,
            onChanged: themeProvider.setDarkMode,
          ),
        ],
      ),
    );
  }
}
