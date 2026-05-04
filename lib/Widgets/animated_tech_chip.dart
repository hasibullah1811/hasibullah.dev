import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTechChip extends StatefulWidget {
  final String label;

  const AnimatedTechChip({super.key, required this.label});

  @override
  State<AnimatedTechChip> createState() => _AnimatedTechChipState();
}

class _AnimatedTechChipState extends State<AnimatedTechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- SMART GREEN PALETTE ---
    // Dark mode: Bright Cyber/Hacker Green. Light mode: Deep Emerald Green.
    final highlightGreen = isDark
        ? Colors.greenAccent[400]!
        : Colors.green[600]!;

    // Default resting colors
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[50];
    final defaultBorderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final defaultTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors
          .basic, // Keeps the standard pointer to feel like a UI element
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ), // Slightly longer for a buttery smooth fade
        curve: Curves.easeOutCubic,
        // The Lift Effect: moves up 3 pixels when hovered
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? highlightGreen : defaultBorderColor,
            width: 1,
          ),
          // --- THE GREEN GLOW ---
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    // Opacity is slightly higher in dark mode to make it pop
                    color: highlightGreen.withOpacity(isDark ? 0.35 : 0.2),
                    blurRadius: 12, // Diffuses the shadow into a soft glow
                    spreadRadius: 1, // Pushes the glow slightly outside the box
                    offset: const Offset(
                      0,
                      4,
                    ), // Casts the glow slightly downward
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.jetBrainsMono(
            color: _isHovered ? highlightGreen : defaultTextColor,
            fontSize: 12,
            // Font weight jumps slightly on hover for extra impact
            fontWeight: _isHovered ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
