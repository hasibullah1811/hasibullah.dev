import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hasib_website/Widgets/pulsuiating_circle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Adds HTML capabilities

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
void main() {
  runApp(const MyMinimalPortfolio());
  // --- PRE-LOADER REMOVAL LOGIC ---
  final loader = html.document.getElementById('loader');

  if (loader != null) {
    // 1. Start the fade out
    loader.style.opacity = '0';
    loader.style.transition = 'opacity 0.5s';

    // 2. Wait 500ms using Dart's native timer, then remove the element
    Future.delayed(const Duration(milliseconds: 500), () {
      loader.remove();
    });
  }
}

class MyMinimalPortfolio extends StatelessWidget {
  const MyMinimalPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hasibullah',
          themeMode: currentMode,

          // --- LIGHT THEME DEFINITION ---
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFAFAFA), // Off-white
            dividerColor: Colors.grey[300],
            cardColor: Colors.white, // For the dock and tiles
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Main text color
              secondary: Color(0xFF166534), // Darker green for light mode
              tertiary: Color(0xFF2563EB), // Blue accent
              surface: Colors.white,
            ),
          ),

          // --- DARK THEME DEFINITION ---
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF050505), // Almost black
            dividerColor: Colors.grey[900],
            cardColor: const Color(0xFF111111),
            colorScheme: const ColorScheme.dark(
              primary: Colors.white, // Main text color
              secondary: Color(0xFF4ADE80), // Neon green for dark mode
              tertiary: Color(0xFF3B82F6), // Blue accent
              surface: Color(0xFF111111),
            ),
          ),

          home: const PortfolioHome(),
        );
      },
    );
  }
}

class PortfolioHome extends StatelessWidget {
  const PortfolioHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Limits width for desktop view to maintain the "document" look
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                children: [
                  const HeaderSection(),
                  const SizedBox(height: 40),
                  const StatusBadge(),

                  const SizedBox(height: 60),

                  const LeetCodeSection(),
                  const SizedBox(height: 60),

                  const EducationSection(),

                  const SizedBox(height: 60),
                  const SectionTitle(title: "WORK HISTORY"),

                  const SizedBox(height: 20),
                  const WorkTile(
                    role: "Production Engineer (Kebabs)",
                    company: "Fairy Meadow Kebabs",
                    date: "2024 - Present",
                    description:
                        "Debugging hunger in a high-concurrency environment. I balance a full-time Master's degree while ensuring zero downtime on garlic sauce deployment.",
                    isLast: false,
                  ),
                  const WorkTile(
                    role: "SOFTWARE DEVELOPER",
                    company: "BinaryCraft",
                    date: "May 2021 - June 2024",
                    description:
                        "Developed and maintained 8+ cross platform mobile applications using Flutter. Collaborated with cross-functional teams to design, develop, and deploy new features. Built the entire ERM system for Sydney based Restaurant.",
                    isLast: false,
                  ),
                  const WorkTile(
                    role: "FULL STACK DEVELOPER (FREELANCE)",
                    company: "UpWork",
                    date: "Sept 2019 - Oct 2023",
                    description:
                        "I worked as a freelance full stack developer on platforms like Upwork, Fiverr, and Contra, where I delivered end-to-end solutions for clients across various industries. My work involved front-end and back-end development, API integration, bug fixes and software testing.",
                    isLast: true,
                  ),

                  const SizedBox(height: 60),
                  const SectionTitle(title: "OWN PROJECTS"),
                  const SizedBox(height: 30),

                  const ProjectItem(
                    title: "StepWise",
                    badge: "FLUTTER + FASTAPI",
                    description:
                        "A comprehensive platform assisting international students in Australia with jobs, accommodation, and community connection.",
                    projectUrl: 'https://thestepwise.com',
                  ),
                  const SizedBox(height: 30),
                  const ProjectItem(
                    title: "Amazing App",
                    badge: "ENCRYPTION SYSTEM",
                    description:
                        "End-to-End file encryption system with facial recognition. Encrypts PDFs/Images and uploads to Drive securely.",
                    projectUrl:
                        'https://github.com/hasibullah1811/Amazing-App-NbM',
                  ),
                  const SizedBox(height: 30),
                  const ProjectItem(
                    title: "MedWay",
                    badge: "HEALTHCARE",
                    description:
                        "Online medicine delivery platform connecting doctors, pharmacists, and consumers.",
                    projectUrl: "",
                  ),
                  const SizedBox(height: 60),

                  // --- INSERT THE NEW SECTION HERE ---
                  const PublicationSection(),
                  const SizedBox(height: 60),

                  const AchievementSection(),
                  const SizedBox(height: 60),

                  const TechSection(),
                  const SizedBox(height: 60),

                  const Footer(),
                  // Bottom padding for the floating dock
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // The Floating Dock
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(child: FloatingDock()),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENTS
// -----------------------------------------------------------------------------

class LocationSection extends StatelessWidget {
  const LocationSection({super.key});

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
        const SectionTitle(title: "CURRENT LOCATION"),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              // Location Icon with a subtle background circle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.locationDot,
                  color: Theme.of(context).colorScheme.tertiary, // Blue accent
                  size: 20,
                ),
              ),
              const SizedBox(width: 20),

              // Text Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wollongong, NSW",
                    style: GoogleFonts.jetBrainsMono(
                      color: primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.earthAmericas,
                        size: 12,
                        color: secondaryText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Australia (GMT+11)",
                        style: GoogleFonts.jetBrainsMono(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // The "Techy" Coordinates part
                  Text(
                    "34.4278° S, 150.8931° E",
                    style: GoogleFonts.jetBrainsMono(
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.grey[600] : Colors.grey[500];

    return Column(
      children: [
        // A subtle separator line
        Divider(
          color: isDark ? Colors.grey[900] : Colors.grey[200],
          thickness: 1,
        ),
        const SizedBox(height: 20),

        // Copyright / Built by
        Text(
          "Built with Flutter by Hasibullah",
          style: GoogleFonts.jetBrainsMono(color: textColor, fontSize: 12),
        ),
        const SizedBox(height: 8),

        // The Attribution
        Text(
          "Design inspiration by Aditya Kumar",
          style: GoogleFonts.jetBrainsMono(
            color: textColor,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class AchievementSection extends StatelessWidget {
  const AchievementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "ACHIEVEMENTS"),
        const SizedBox(height: 20),
        const AchievementItem(
          title: "Top 10 Flutter Developers",
          organization: "Upwork",
          year: "2022",
          description:
              "Recognized for consistent high-quality delivery and client satisfaction ratings on the platform.",
        ),
        const SizedBox(height: 16),
        const AchievementItem(
          title: "Ranked #8 Dart Contributor",
          organization: "Bangladesh Developer Community",
          year: "2022",
          description:
              "Ranked for having the most open-source contributions to the Dart ecosystem from the region.",
        ),
      ],
    );
  }
}

class AchievementItem extends StatelessWidget {
  final String title;
  final String organization;
  final String year;
  final String description;

  const AchievementItem({
    super.key,
    required this.title,
    required this.organization,
    required this.year,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trophy Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF332b00)
                  : const Color(0xFFFEFCE8), // Gold tint bg
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3), // Gold border
              ),
            ),
            child: const Icon(
              FontAwesomeIcons.trophy,
              size: 16,
              color: Color(0xFFFFD700), // Gold Color
            ),
          ),
          const SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: GoogleFonts.jetBrainsMono(
                          color: primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      year,
                      style: GoogleFonts.jetBrainsMono(
                        color: secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  organization,
                  style: GoogleFonts.jetBrainsMono(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary, // Green accent
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.jetBrainsMono(
                    color: secondaryText,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper to get dynamic colors
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "hey, i'm hasib ",
              style: GoogleFonts.playfairDisplay(
                color: colorScheme.primary, // Changed from Colors.white
                fontSize: 32,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text("👋", style: TextStyle(fontSize: 28)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "I started to code when I was 16. Been in the game ever since. Crafting apps is my jam, turning ideas into pixel-perfect reality. I'm that guy who finds peace in the rattling of the keyboard.",
          style: GoogleFonts.jetBrainsMono(
            // Darker grey for light mode, Lighter grey for dark mode
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF052e16), // Very dark green bg
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4ADE80).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  "open for work!",
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFF4ADE80),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Text Details
            isMobile
                ? Container()
                : LocationTile(secondaryText: secondaryText, isDark: isDark),
          ],
        ),
        SizedBox(height: isMobile ? 20 : 0),
        isMobile
            ? LocationTile(secondaryText: secondaryText, isDark: isDark)
            : Container(),
      ],
    );
  }
}

class LocationTile extends StatelessWidget {
  const LocationTile({
    super.key,
    required this.secondaryText,
    required this.isDark,
  });

  final Color? secondaryText;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              FontAwesomeIcons.earthAmericas,
              size: 12,
              color: secondaryText,
            ),
            const SizedBox(width: 8),
            Text(
              "Wollongong, NSW, Australia (GMT+11)",
              style: GoogleFonts.jetBrainsMono(
                color: secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // The "Techy" Coordinates part
        Text(
          "34.4278° S, 150.8931° E",
          style: GoogleFonts.jetBrainsMono(
            color: isDark ? Colors.grey[600] : Colors.grey[400],
            fontSize: 10,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class LeetCodeSection extends StatelessWidget {
  const LeetCodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];

    // LeetCode Colors
    const easyColor = Color(0xFF00B8A3);
    const mediumColor = Color(0xFFFFC01E);
    const hardColor = Color(0xFFFF375F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "DSA/CONTINIOUS LEARNING"),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Profile & Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.code,
                        color: secondaryText,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LeetCode",
                            style: GoogleFonts.jetBrainsMono(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Max Streak: 3 Days", // Update this!
                            style: GoogleFonts.jetBrainsMono(
                              color: secondaryText,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "32 Solved", // Update this!
                    style: GoogleFonts.jetBrainsMono(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress Bars
              _buildStatRow("Easy", 8, 50, easyColor, context),
              const SizedBox(height: 12),
              _buildStatRow("Medium", 19, 50, mediumColor, context),
              const SizedBox(height: 12),
              _buildStatRow("Hard", 5, 50, hardColor, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(
    String label,
    int solved,
    int total,
    Color color,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgBar = isDark ? Colors.grey[800] : Colors.grey[200];
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: GoogleFonts.jetBrainsMono(color: labelColor, fontSize: 12),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              // Background Bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: bgBar,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Foreground Bar (The actual progress)
              FractionallySizedBox(
                widthFactor:
                    solved / total, // Calculates percentage automatically
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 50,
          child: Text(
            "$solved",
            textAlign: TextAlign.end,
            style: GoogleFonts.jetBrainsMono(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 2,
          color: const Color(0xFF3B82F6), // Blue accent
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.grey[600],
            fontSize: 12,
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class WorkTile extends StatelessWidget {
  final String role;
  final String company;
  final String date;
  final String description;
  final bool isLast;

  const WorkTile({
    super.key,
    required this.role,
    required this.company,
    required this.date,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // Helper to get dynamic colors
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.only(bottom: 20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Icon(
                FontAwesomeIcons.briefcase,
                size: 14,
                color: isDark ? Colors.grey[400] : Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: GoogleFonts.jetBrainsMono(
                      color: isDark ? Colors.white : Colors.grey[800],
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[800],
                      ),
                      children: [
                        TextSpan(text: company),
                        const TextSpan(text: "  •  "),
                        TextSpan(text: date),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 56), // Align with text
            child: Text(
              description,
              style: GoogleFonts.jetBrainsMono(
                color: isDark ? Colors.grey[400] : Colors.grey[800],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  final String title;
  final String badge;
  final String description;
  final String projectUrl;

  const ProjectItem({
    super.key,
    required this.title,
    required this.badge,
    required this.description,
    required this.projectUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Future<void> _launchUrl() async {
      final Uri uri = Uri.parse(projectUrl);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.jetBrainsMono(
                color: isDark ? Colors.grey[400] : Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.code,
                    size: 10,
                    color: isDark ? Colors.grey[500] : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    badge.toLowerCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: isDark ? Colors.grey[400] : Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: GoogleFonts.jetBrainsMono(
            color: isDark ? Colors.grey[400] : Colors.grey[800],
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _launchUrl,
          child: Container(
            width: 70,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View',
                  style: GoogleFonts.jetBrainsMono(
                    color: isDark ? Colors.grey[400] : Colors.grey[800],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 10),
                const PulsatingCircle(size: 12, color: Colors.greenAccent),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey[900], thickness: 1),
      ],
    );
  }
}

class FloatingDock extends StatelessWidget {
  const FloatingDock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Future<void> _launchUrl(String projectUrl) async {
      final Uri uri = Uri.parse(projectUrl);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    }

    Future<void> _launchEmail(String emailAddress) async {
      final Uri emailLaunchUri = Uri(scheme: 'mailto', path: emailAddress);

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Handle the case where no email app is available
        throw 'Could not launch $emailLaunchUri';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        // Dynamic background color (White in light mode, Dark Grey in dark mode)
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
          _DockIcon(
            icon: FontAwesomeIcons.github,
            onTap: () {
              _launchUrl("https://github.com/hasibullah1811");
            },
          ),
          const SizedBox(width: 20),
          _DockIcon(
            icon: FontAwesomeIcons.linkedin,
            onTap: () {
              _launchUrl(
                "https://www.linkedin.com/in/md-hasibullah-hasib-39a89a3a5/",
              );
            },
          ),
          const SizedBox(width: 20),
          _DockIcon(
            icon: FontAwesomeIcons.envelope,
            onTap: () {
              _launchEmail('hasib.mobiledev@gmail.com');
            },
          ),
          const SizedBox(width: 20),
          Container(
            width: 1,
            height: 20,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          const SizedBox(width: 20),
          // The Theme Toggle Button
          _DockIcon(
            icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onTap: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
    );
  }
}

class TechSection extends StatelessWidget {
  const TechSection({super.key});

  final List<String> techStack = const [
    "Flutter",
    "Dart",
    "Python",
    "FastAPI",
    "NestJS",
    "MongoDB",
    "Firebase",
    "SQL",
    "Git",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "TECH"),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: techStack.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Text(
              techStack[index],
              style: GoogleFonts.jetBrainsMono(
                // Dynamic grey color
                color: isDark ? Colors.grey[400] : Colors.grey[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            );
          },
        ),
      ],
    );
  }
}

class PublicationSection extends StatelessWidget {
  const PublicationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "PUBLICATION"),
        const SizedBox(height: 20),
        const PublicationTile(
          title:
              "Deep Learning to Aid Prescription Processing & Inventory Management for Local Pharmacies through Smartphone Application",
          publisher:
              "International Journal of Supply Chain & Management (IJSCM)",
          meta: "Primary Author • Vol. 10, No. 4, Aug 2021",
          link:
              "https://ojs.excelingtech.co.uk/", // Replace with actual paper link if you have one
        ),
      ],
    );
  }
}

class PublicationTile extends StatelessWidget {
  final String title;
  final String publisher;
  final String meta;
  final String link;

  const PublicationTile({
    super.key,
    required this.title,
    required this.publisher,
    required this.meta,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = Theme.of(context).cardColor;
    final borderColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.fileLines,
                color: Theme.of(context).colorScheme.tertiary, // Blue accent
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.jetBrainsMono(
                        color: primaryText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      publisher,
                      style: GoogleFonts.jetBrainsMono(
                        color: secondaryText,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            meta,
                            style: GoogleFonts.jetBrainsMono(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary, // Green accent
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // External Link Icon
                        Icon(
                          FontAwesomeIcons.arrowUpRightFromSquare,
                          size: 12,
                          color: secondaryText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "EDUCATION"),
        const SizedBox(height: 20),

        // Macquarie University (Current)
        const EducationTile(
          institution: "Macquarie University",
          degree: "Master of IT in Artificial Intelligence",
          year: "2024 - Present", // Estimated start based on undergrad grad
          description:
              "Focusing on advanced AI methodologies and machine learning systems.",
          isFirst: true,
        ),

        // North South University
        const EducationTile(
          institution: "North South University",
          degree: "B.Sc. in Computer Science & Engineering",
          year: "Graduated 2024",
          description:
              "Major in AI. Completed thesis on Large Language Models (LLM).",
        ),

        // High School
        const EducationTile(
          institution: "Uttara High School and College",
          degree: "HSC & SSC",
          year: "Dhaka, Bangladesh",
          description: "Science concentration. Graduated with distinction.",
          isLast: true,
        ),
      ],
    );
  }
}

class EducationTile extends StatelessWidget {
  final String institution;
  final String degree;
  final String year;
  final String description;
  final bool isFirst;
  final bool isLast;

  const EducationTile({
    super.key,
    required this.institution,
    required this.degree,
    required this.year,
    required this.description,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          Column(
            children: [
              // Top line (invisible for first item)
              Container(
                width: 2,
                height: 20,
                color: isFirst
                    ? Colors.transparent
                    : (isDark ? Colors.grey[800] : Colors.grey[300]),
              ),
              // Dot
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isFirst ? tertiaryColor : Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFirst
                        ? tertiaryColor
                        : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                    width: 2,
                  ),
                ),
              ),
              // Bottom line (extends to bottom, invisible for last item)
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast
                      ? Colors.transparent
                      : (isDark ? Colors.grey[800] : Colors.grey[300]),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 30,
              ), // Spacing between items
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    institution,
                    style: GoogleFonts.jetBrainsMono(
                      color: primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          degree,
                          style: GoogleFonts.jetBrainsMono(
                            color: secondaryText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        year,
                        style: GoogleFonts.jetBrainsMono(
                          color: secondaryText,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: GoogleFonts.jetBrainsMono(
                      color: secondaryText!.withOpacity(0.8), // Slightly dimmer
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _DockIcon({required this.icon, required this.onTap});

  @override
  State<_DockIcon> createState() => _DockIconState();
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
