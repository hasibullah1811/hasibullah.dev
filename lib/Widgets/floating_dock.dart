import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hasib_website/main.dart';
import 'package:url_launcher/url_launcher.dart';

class _DockIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DockIcon({required this.icon, required this.onTap});

  @override
  State<_DockIcon> createState() => _DockIconState();
}

// Helper to open URLs
Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

class _DockIconState extends State<_DockIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.2 : 1.0),
          child: Icon(
            widget.icon,
            color: _isHovered ? Colors.white : Colors.grey[500],
            size: 20,
          ),
        ),
      ),
    );
  }
}

class FloatingDock extends StatelessWidget {
  const FloatingDock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- THE JOKE DATABASE ---
    final List<String> lightModeJokes = [
      "MY EYES! IT BURNS! 🔥",
      "Flashbang deployed! 💥",
      "Warning: Solar flare detected. Sunglasses advised. 🕶️",
      "Dark mode is for coders. Light mode is for... psychopaths.",
      "System Overload: Brightness at 1000% ☀️",
      "Why would you do this? The bugs like the dark. 🐛",
      "Retina burn initiated in 3... 2... 1...",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Standard Links
          _DockIcon(
            icon: FontAwesomeIcons.github,
            onTap: () => _launchUrl('https://github.com/hasibullah1811'),
          ),
          const SizedBox(width: 20),
          _DockIcon(
            icon: FontAwesomeIcons.linkedin,
            onTap: () => _launchUrl(
              'https://www.linkedin.com/in/md-hasibullah-hasib-39a89a3a5/',
            ),
          ),
          const SizedBox(width: 20),
          _DockIcon(
            icon: FontAwesomeIcons.envelope,
            onTap: () => _launchUrl('mailto:hasib.mobiledev@gmail.com'),
          ),
          const SizedBox(width: 20),
          _DockIcon(
            icon: FontAwesomeIcons.download,
            onTap: () => _launchUrl(
              'https://raw.githubusercontent.com/hasibullah1811/hasibullah.dev/main/assets/Hasibullah_Hasib_Resume.pdf',
            ),
          ),
          const SizedBox(width: 20),

          // Divider
          Container(
            width: 1,
            height: 20,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(width: 20),
          // Inside FloatingDock...
          _DockIcon(
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onTap: () {
              if (isDark) {
                // 1. Pick a joke
                final random = Random();
                final message =
                    lightModeJokes[random.nextInt(lightModeJokes.length)];

                // 2. Trigger the FlashAlert (Simple!)
                flashNotifier.value = message;

                // Force update if the message happens to be the same (optional hack)
                // flashNotifier.notifyListeners(); // Not available publicly, but value change is usually enough.
              }

              // 3. Toggle Theme
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
    );
  }
}
