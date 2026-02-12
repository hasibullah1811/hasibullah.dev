import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hasib_website/main.dart';

class FlashAlert extends StatefulWidget {
  const FlashAlert({super.key});

  @override
  State<FlashAlert> createState() => _FlashAlertState();
}

class _FlashAlertState extends State<FlashAlert> {
  String _message = "";
  bool _isVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Listen for new messages
    flashNotifier.addListener(_showFlash);
  }

  @override
  void dispose() {
    flashNotifier.removeListener(_showFlash);
    _timer?.cancel();
    super.dispose();
  }

  void _showFlash() {
    if (flashNotifier.value.isEmpty) return;

    setState(() {
      _message = flashNotifier.value;
      _isVisible = true;
    });

    // Reset timer if already running (so consecutive clicks stay visible)
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Top-Center Position
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack, // Gives it a nice "spring" effect
      top: _isVisible ? 50 : -100, // Slide in/out logic
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9), // Always dark for contrast
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF4ADE80),
              width: 1.5,
            ), // Green border
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ADE80).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFF4ADE80),
                size: 20,
              ),
              const SizedBox(width: 12),
              // The Text
              Text(
                _message,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
