import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hasib_website/Widgets/architecture_module.dart';

class ProjectItem extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final String? liveUrl;
  final String? repoUrl;
  final List<ProjectMetric>? metrics;
  final bool isCommercial;
  // --- NEW PROPERTIES FOR ARCHITECTURE MODAL ---
  final String? archImagePath;
  final String? archDescription;

  const ProjectItem({
    super.key,
    required this.title,
    required this.badge,
    required this.description,
    this.isCommercial = false,
    this.liveUrl,
    this.repoUrl,
    this.archImagePath,
    this.archDescription,
    this.metrics,
  });

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
                color: isCommercial ? Colors.amber.withOpacity(0.1) : cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCommercial
                      ? Colors.amber.withOpacity(0.5)
                      : borderColor,
                ),
              ),
              child: Row(
                children: [
                  isCommercial
                      ? Icon(Icons.verified, size: 10, color: Colors.amber[700])
                      : FaIcon(
                          FontAwesomeIcons.code,
                          size: 10,
                          color: secondaryText,
                        ),
                  const SizedBox(width: 6),
                  Text(
                    isCommercial
                        ? "${badge.toLowerCase()} (COMMERCIAL)"
                        : badge.toLowerCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: isCommercial ? Colors.amber[700] : secondaryText,
                      fontSize: 10,
                      fontWeight: isCommercial
                          ? FontWeight.bold
                          : FontWeight.normal,
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
        // --- METRICS ROW ---
        if (metrics != null && metrics!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: metrics!.map((metric) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(size: 12, color: secondaryText),
                      child: metric.icon,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${metric.label}: ",
                      style: GoogleFonts.jetBrainsMono(
                        color: secondaryText,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      metric.value,
                      style: GoogleFonts.jetBrainsMono(
                        // Uses the highlight color if provided, otherwise defaults to primary text
                        color: metric.valueHighlight ?? primaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        // --- LINKS & ACTIONS ROW ---
        if (liveUrl != null || repoUrl != null || archImagePath != null) ...[
          const SizedBox(height: 16),
          Row(
            spacing: 20, // Horizontal space between buttons
            // runSpacing: 12, // Vertical space if they wrap on mobile
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // 1. Architecture Button (Fires the Modal)
              if (archImagePath != null && archDescription != null)
                _ProjectLink(
                  icon: Icon(Icons.account_tree_outlined, size: 14),
                  label: "Architecture",
                  isHighlight: true,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ArchitectureModal(
                        projectName: title,
                        imagePath: archImagePath!,
                        description: archDescription!,
                      ),
                    );
                  },
                ),

              // 2. GitHub Link
              if (repoUrl != null)
                _ProjectLink(
                  icon: FaIcon(FontAwesomeIcons.github, size: 14),
                  label: "Code",
                  onTap: () => _launchUrl(repoUrl!),
                ),

              // 3. Live Demo Link
              if (liveUrl != null)
                _ProjectLink(
                  icon: FaIcon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    size: 14,
                  ),
                  label: "Live Demo",
                  onTap: () => _launchUrl(liveUrl!),
                ),
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
  final Widget icon;
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
              IconTheme(
                data: IconThemeData(
                  size: 14,
                  color: _isHovered
                      ? Theme.of(context).colorScheme.secondary
                      : color,
                ),
                child: widget.icon,
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

class ProjectMetric {
  final Widget icon;
  final String label;
  final String value;
  final Color?
  valueHighlight; // Optional: To make the number pop (e.g., Green for 99%)

  const ProjectMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.valueHighlight,
  });
}
