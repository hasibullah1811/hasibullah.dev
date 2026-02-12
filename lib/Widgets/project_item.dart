import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectItem extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final String? liveUrl; // Optional: Link to live demo
  final String? repoUrl; // Optional: Link to GitHub code

  const ProjectItem({
    super.key,
    required this.title,
    required this.badge,
    required this.description,
    this.liveUrl,
    this.repoUrl,
  });

  // Helper to open URLs
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER ROW (Title + Badge) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.jetBrainsMono(
                color: primaryText,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.code, size: 10, color: secondaryText),
                  const SizedBox(width: 6),
                  Text(
                    badge.toLowerCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: secondaryText,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // --- DESCRIPTION ---
        Text(
          description,
          style: GoogleFonts.jetBrainsMono(
            color: secondaryText,
            fontSize: 13,
            height: 1.5,
          ),
        ),

        // --- NEW: LINKS ROW (Only shows if URLs exist) ---
        if (liveUrl != null || repoUrl != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              // GitHub Link
              if (repoUrl != null) ...[
                _ProjectLink(
                  icon: FontAwesomeIcons.github,
                  label: "Code",
                  onTap: () => _launchUrl(repoUrl!),
                ),
                const SizedBox(width: 20),
              ],

              // Live Demo Link
              if (liveUrl != null) ...[
                _ProjectLink(
                  icon: FontAwesomeIcons.arrowUpRightFromSquare,
                  label: "Live Demo",
                  onTap: () => _launchUrl(liveUrl!),
                  isHighlight: true, // Makes it stand out slightly
                ),
              ],
            ],
          ),
        ],

        const SizedBox(height: 12),
        Divider(color: borderColor, thickness: 1),
      ],
    );
  }
}

// Small helper widget for the link buttons
class _ProjectLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isHighlight;

  const _ProjectLink({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isHighlight = false,
  });

  @override
  State<_ProjectLink> createState() => _ProjectLinkState();
}

class _ProjectLinkState extends State<_ProjectLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Highlight color is Blue or Green, regular is Grey
    final color = widget.isHighlight
        ? Theme.of(context).colorScheme.tertiary
        : (isDark ? Colors.grey[400] : Colors.grey[600]);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // Subtle lift effect on hover
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _isHovered
                    ? Theme.of(context).colorScheme.secondary
                    : color,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.jetBrainsMono(
                  color: _isHovered
                      ? Theme.of(context).colorScheme.secondary
                      : color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: _isHovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
