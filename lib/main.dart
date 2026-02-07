import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'providers/tasks_provider.dart';
import 'providers/theme_mode_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/tasks_screen.dart';

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

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.checkmark_circle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeScreen();
              case 1:
                return const TasksScreen();
              case 2:
                return const SettingsScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}
