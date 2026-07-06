import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SystemDesignCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final String proof;
  final Color accentColor;
  final bool isWide;

  const SystemDesignCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.proof,
    required this.accentColor,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.jetBrainsMono(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final descriptionStyle = GoogleFonts.jetBrainsMono(
      fontSize: 13,
      color: Colors.grey[400],
      height: 1.5,
    );
    final proofStyle = GoogleFonts.jetBrainsMono(
      fontSize: 11,
      fontStyle: FontStyle.italic,
      color: accentColor.withOpacity(0.85),
      height: 1.4,
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isWide) ...[
          icon,
          const SizedBox(height: 16),
        ],
        Text(title, style: titleStyle),
        const SizedBox(height: 10),
        Text(description, style: descriptionStyle),
        const SizedBox(height: 16),
        Divider(color: Colors.grey[800], thickness: 1),
        const SizedBox(height: 12),
        Text(proof, style: proofStyle),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(
            color: accentColor.withOpacity(0.5),
            width: 2,
          ),
        ),
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 20),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }
}
