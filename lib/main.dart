import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

class AppColors {
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF111111);
  static const surfaceHover = Color(0xFF161616);
  static const border = Color(0xFF1F1F1F);
  static const borderHover = Color(0xFF333333);
  static const textPrimary = Color(0xFFEDEDED);
  static const textSecondary = Color(0xFFA1A1A1);
  static const textMuted = Color(0xFF6B6B6B);
  static const accent = Color(0xFF4ADE80);
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hasibullah Hasib',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.textPrimary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        textTheme: baseText.copyWith(
          headlineLarge: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
            height: 1.15,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColors.textMuted,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.35,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.65,
          ),
          bodyMedium: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
            height: 1.5,
          ),
          labelLarge: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.accent,
            letterSpacing: 0.2,
          ),
        ),
      ),
      home: const PortfolioPage(),
    );
  }
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontal = MediaQuery.sizeOf(context).width < 600 ? 20.0 : 32.0;
    final vertical = MediaQuery.sizeOf(context).width < 600 ? 48.0 : 80.0;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontal,
              vertical: vertical,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroSection(),
                SizedBox(height: 72),
                SkillsSection(),
                SizedBox(height: 72),
                ExperienceSection(),
                SizedBox(height: 72),
                ProjectsSection(),
                SizedBox(height: 72),
                EducationSection(),
                SizedBox(height: 96),
                SiteFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared
// ---------------------------------------------------------------------------

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(width: 16),
          Expanded(child: Container(height: 1, color: AppColors.border)),
        ],
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  const HoverCard({super.key, required this.child});

  final Widget child;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surfaceHover : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? AppColors.borderHover : AppColors.border,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ---------------------------------------------------------------------------
// 1. Hero
// ---------------------------------------------------------------------------

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 520;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasibullah Hasib',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: isNarrow ? 28 : 36),
        ),
        const SizedBox(height: 12),
        Text(
          'Software Developer',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: isNarrow ? 15 : 17,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Text('Sydney, NSW', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _ContactLink(
              label: 'hi@hasibullah.dev',
              url: 'mailto:hi@hasibullah.dev',
            ),
            _Dot(),
            _ContactLink(
              label: 'hasibullah.dev',
              url: 'https://hasibullah.dev',
            ),
            _Dot(),
            _ContactLink(
              label: 'github.com/hasibullah1811',
              url: 'https://github.com/hasibullah1811',
            ),
          ],
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
    );
  }
}

class _ContactLink extends StatefulWidget {
  const _ContactLink({required this.label, required this.url});

  final String label;
  final String url;

  @override
  State<_ContactLink> createState() => _ContactLinkState();
}

class _ContactLinkState extends State<_ContactLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _openUrl(widget.url),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            color: _hovered ? AppColors.accent : AppColors.textSecondary,
            decoration: _hovered
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.accent,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Skills
// ---------------------------------------------------------------------------

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _groups = [
    (
      'Languages',
      'JavaScript/TypeScript, Python, SQL (MySQL, PostgreSQL), Dart, Java/Kotlin',
    ),
    ('Frameworks', 'React, Firebase, RESTful APIs, Flutter, Flask, Nest.JS'),
    (
      'Developer Tools',
      'GitHub (CI/CD Pipelines), Vector Databases, Retrieval-Augmented Generation (RAG), Vercel, RailWay, Linux/Ubuntu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Skills'),
        ..._groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(group.$1, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(group.$2, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Experience
// ---------------------------------------------------------------------------

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel('Experience'),
        ExperienceCard(
          role: 'Full-Stack Developer',
          company: 'Elements Bar and Grill',
          location: 'Sydney, Australia',
          dates: 'July 2024 – July 2026',
          bullets: [
            'Centralized daily operations across 5 restaurant locations by building a complete ERP system with a Python backend to manage inventory and logistics.',
            'Sped up food preparation for 500 to 700 daily orders by creating a Flutter iPad app that routes incoming orders directly to kitchen printers.',
            'Tracked accurate work hours for 180 staff members by developing a Flutter mobile app with a real-time, location-based clock-in and clock-out system.',
          ],
        ),
        SizedBox(height: 16),
        ExperienceCard(
          role: 'Mobile Developer',
          company: 'Binary Craft',
          location: 'Dhaka, Bangladesh',
          dates: 'May 2021 – June 2024',
          bullets: [
            'Delivered 5 complete property and invoice management apps using Flutter and React, speeding up invoice processing times for clients by 20%.',
            'Delivered custom software systems directly to international clients, successfully securing a development contract with Elements Bar and Grill in Australia.',
          ],
        ),
      ],
    );
  }
}

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    super.key,
    required this.role,
    required this.company,
    required this.location,
    required this.dates,
    required this.bullets,
  });

  final String role;
  final String company;
  final String location;
  final String dates;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 520;

    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNarrow) ...[
            Text(role, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '$company · $location',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(dates, style: Theme.of(context).textTheme.bodyMedium),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(role, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        '$company · $location',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(dates, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          const SizedBox(height: 16),
          ...bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyLarge,
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

// ---------------------------------------------------------------------------
// 4. Projects
// ---------------------------------------------------------------------------

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel('Projects'),
        ProjectCard(
          title: 'Helping Hand',
          stack: 'Flutter, Dart, Python, Flask, Firebase',
          bullets: [
            'Built a community assistance Android app allowing users to post and fulfill emergency support requests during the COVID-19 lockdown.',
            'Scaled the application to support 2,000 active users, reliably processing and routing over 50 real-time help requests per day.',
          ],
        ),
        SizedBox(height: 16),
        ProjectCard(
          title: 'Minima',
          stack: 'Open Source, Machine Learning',
          bullets: [
            'Built an ongoing open-source tool that visualizes how Machine Learning algorithms work behind the scenes, making complex AI mechanics easy to see.',
            'Actively managing the public codebase, designing interactive features that help developers and students clearly understand how AI models are trained.',
          ],
        ),
        SizedBox(height: 16),
        ProjectCard(
          title: 'Prism RAG Visualizer',
          stack: 'Python, Vector Database, React',
          bullets: [
            'Built a visual tool for Retrieval-Augmented Generation (RAG) systems that renders scatter plots and map views to track vector matches.',
            'Sped up system troubleshooting by building JSON export features, allowing developers to save and analyze LLM token attribution data.',
          ],
        ),
        SizedBox(height: 16),
        ProjectCard(
          title: 'Stepwise',
          stack: 'Python, Flask, Flutter, PostgreSQL',
          bullets: [
            'Built and released the web beta of a complete student platform, handling all the development myself using Flutter, Python, and Flask.',
            'Set up a fast, reliable PostgreSQL database and clean APIs to handle current web traffic and prepare for the upcoming mobile app launch.',
          ],
        ),
      ],
    );
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.stack,
    required this.bullets,
  });

  final String title;
  final String stack;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(stack, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 14),
          ...bullets.map(
            (bullet) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 12),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodyLarge,
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

// ---------------------------------------------------------------------------
// 5. Education
// ---------------------------------------------------------------------------

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel('Education'),
        EducationItem(
          degree: 'Master of Information Technology in Artificial Intelligence',
          school: 'Macquarie University',
          location: 'Sydney, NSW',
          year: 'Graduated 2026',
        ),
        SizedBox(height: 16),
        EducationItem(
          degree: 'Bachelor of Science in Computer Science and Engineering',
          school: 'North South University',
          location: 'Dhaka, Bangladesh',
          year: 'Graduated 2024',
        ),
      ],
    );
  }
}

class EducationItem extends StatelessWidget {
  const EducationItem({
    super.key,
    required this.degree,
    required this.school,
    required this.location,
    required this.year,
  });

  final String degree;
  final String school;
  final String location;
  final String year;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.sizeOf(context).width < 520;

    return HoverCard(
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(degree, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  '$school · $location',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(year, style: Theme.of(context).textTheme.bodyMedium),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        degree,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$school · $location',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(year, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Footer
// ---------------------------------------------------------------------------

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: AppColors.border),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '© 2026 Hasibullah Hasib · ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const _ContactLink(
              label: 'hi@hasibullah.dev',
              url: 'mailto:hi@hasibullah.dev',
            ),
          ],
        ),
      ],
    );
  }
}
