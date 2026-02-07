import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      const SizedBox(height: 12),
                      GlassPanel(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: CupertinoListSection.insetGrouped(
                          backgroundColor: CupertinoColors.transparent,
                          separatorColor: CupertinoColors.separator,
                          header: const Text('Developer Contact'),
                          children: [
                            CupertinoListTile(
                              backgroundColor: CupertinoColors.transparent,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(64),
                                child: Image.asset(
                                  'assets/my.png',
                                  width: 128,
                                  height: 128,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 128,
                                      height: 128,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey4,
                                        borderRadius: BorderRadius.circular(64),
                                      ),
                                      child: const Text(
                                        'SV',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: CupertinoColors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              title: const Text('Sabari Vasan'),
                              subtitle: const Text('Developer'),
                            ),
                            CupertinoListTile(
                              backgroundColor: CupertinoColors.transparent,
                              title: const Text('Portfolio'),
                              subtitle: const Text(
                                'https://portfolio.vasan.tech/',
                              ),
                              trailing: const Icon(CupertinoIcons.link),
                              onTap: () => _openUrl(
                                context,
                                'https://portfolio.vasan.tech/',
                              ),
                            ),
                            CupertinoListTile(
                              backgroundColor: CupertinoColors.transparent,
                              title: const Text('LinkedIn'),
                              subtitle: const Text(
                                'https://www.linkedin.com/in/sabarivasan-s-m-b10229255/',
                              ),
                              trailing: const Icon(CupertinoIcons.link),
                              onTap: () => _openUrl(
                                context,
                                'https://www.linkedin.com/in/sabarivasan-s-m-b10229255/',
                              ),
                            ),
                            CupertinoListTile(
                              backgroundColor: CupertinoColors.transparent,
                              title: const Text('GitHub'),
                              subtitle: const Text(
                                'https://github.com/Sabari-Vasan-SM',
                              ),
                              trailing: const Icon(CupertinoIcons.link),
                              onTap: () => _openUrl(
                                context,
                                'https://github.com/Sabari-Vasan-SM',
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

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) {
        return;
      }
      _showError(context, 'Could not open the link.');
    }
  }

  void _showError(BuildContext context, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Unable to Open Link'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
