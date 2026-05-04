import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcsMemberBadge extends StatelessWidget {
  const AcsMemberBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        // A subtle, professional blue background
        color: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFE0E7FF),
        border: Border.all(
          // Slightly brighter blue border
          color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFF818CF8),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20), // Perfect pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrinks to fit content perfectly
        children: [
          // A tiny "active" dot for visual flair
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF4338CA),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "ACS Member", // Change to "MACS" if you hold that specific grade
            style: GoogleFonts.jetBrainsMono(
              color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF3730A3),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
