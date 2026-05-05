import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArchitectureModal extends StatelessWidget {
  final String projectName;
  final String imagePath;
  final String description;

  const ArchitectureModal({
    super.key,
    required this.projectName,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : Colors.black87;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Ensures the modal doesn't touch the very edges of mobile screens
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(20), // Slightly reduced for mobile
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          // --- FIX #1: SingleChildScrollView handles vertical overflow ---
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns to top if text wraps
                  children: [
                    // --- FIX #2: Expanded forces the text to wrap instead of overflowing ---
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ), // Align visually with the icon button
                        child: Text(
                          "$projectName // SYSTEM ARCHITECTURE",
                          style: GoogleFonts.jetBrainsMono(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // Buffer between text and button
                    IconButton(
                      icon: Icon(Icons.close, color: primaryText),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: "Close",
                      padding:
                          EdgeInsets.zero, // Tightens the tap target slightly
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- THE DIAGRAM ---
                Container(
                  width: double.infinity,
                  height:
                      250, // Slightly reduced height to fit mobile screens better
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0A0A0A) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      mouseCursor: SystemMouseCursors.zoomIn,
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) {
                              return FullScreenImageViewer(
                                imagePath: imagePath,
                              );
                            },
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.zoom_out_map,
                                size: 14,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- THE EXPLANATION ---
                Text(
                  "DATA FLOW & BUSINESS LOGIC",
                  style: GoogleFonts.jetBrainsMono(
                    color: primaryText,
                    fontSize: 14, // Slightly scaled down for mobile readability
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.jetBrainsMono(
                    color: secondaryText,
                    fontSize: 13, // Scaled for mobile
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imagePath;

  const FullScreenImageViewer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A deep, dark semi-transparent background to focus on the diagram
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        children: [
          // 1. The Zoomable Image
          Center(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
          ),

          // 2. The Close Button (Top Right)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: "Close Full Screen",
                ),
              ),
            ),
          ),

          // 3. Optional: Helpful hint at the bottom
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "Pinch or scroll to zoom. Drag to pan.",
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
