import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hasib_website/Widgets/acsMember_badge.dart';
import 'package:hasib_website/Widgets/animated_tech_chip.dart';
import 'package:hasib_website/Widgets/flash_alert.dart';
import 'package:hasib_website/Widgets/floating_dock.dart';
import 'package:hasib_website/Widgets/project_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html; // Adds HTML capabilities

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);
// Signal to show a flash message
final ValueNotifier<String> flashNotifier = ValueNotifier("");
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
  // Helper method for the column
  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.greenAccent,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(color: Colors.white, fontSize: 13),
        ),
      ],
    );
  }

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
                  const ActiveThreadsSection(),
                  const SizedBox(height: 60),

                  const TerminalChat(),
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

                  ProjectItem(
                    title: "StepWise",
                    badge: "FLUTTER + FASTAPI",
                    description:
                        "A comprehensive platform assisting international students in Australia with jobs, accommodation, and community connection.",
                    liveUrl: 'https://thestepwise.com',
                    archImagePath: "assets/stepwise-diagram.png",
                    archDescription:
                        "The Flutter frontend communicates securely via an AWS API Gateway. Business logic and routing are handled by a FastAPI service, which reads and writes to a PostgreSQL database, while document storage is delegated to AWS S3.",

                    metrics: [
                      ProjectMetric(
                        icon: Icons.people_outline,
                        label: "Concurrent Users",
                        value: "500+",
                      ),
                      ProjectMetric(
                        icon: Icons.storage,
                        label: "DB Query Optimization",
                        value: "40% faster",
                        valueHighlight: Colors.greenAccent[400],
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ProjectItem(
                    title: "Prism",
                    badge: "LangChain + Scikit-learn + TikToken",
                    description:
                        "Prism is a full-stack developer tool for visualizing and debugging RAG (Retrieval-Augmented Generation) pipelines. It helps engineers understand how text chunking strategies (Token size, Overlap) affect retrieval accuracy.",
                    repoUrl: 'https://github.com/hasibullah1811/prism',
                    liveUrl: 'https://prism-xi-three.vercel.app/',
                    archImagePath: "assets/prism-diagram.png",
                    archDescription:
                        "The React frontend captures user parameters and transmits them to the Python backend via REST. The backend processes the chunking logic using LangChain, queries the LLM, and returns the vectorized overlaps back to the UI for D3.js rendering. This decouples the heavy mathematical lifting from the client interface.",
                    metrics: [
                      ProjectMetric(
                        icon: Icons.speed,
                        label: "Lighthouse Performance",
                        value: "98",
                        valueHighlight:
                            Colors.greenAccent[400], // Makes it glow green
                      ),
                      ProjectMetric(
                        icon: Icons.memory,
                        label: "Vector Processing Latency",
                        value: "<120ms",
                        valueHighlight: Colors.cyanAccent[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const ProjectItem(
                    title: "Amazing App",
                    badge: "ENCRYPTION SYSTEM",
                    description:
                        "End-to-End file encryption system with facial recognition. Encrypts PDFs/Images and uploads to Drive securely.",
                    repoUrl:
                        'https://github.com/hasibullah1811/Amazing-App-NbM',
                  ),
                  const SizedBox(height: 30),
                  const ProjectItem(
                    title: "MedWay",
                    badge: "HEALTHCARE",
                    description:
                        "Online medicine delivery platform connecting doctors, pharmacists, and consumers.",
                    repoUrl: "https://github.com/hasibullah1811/medway",
                  ),
                  const SizedBox(height: 60),

                  // --- INSERT THE NEW SECTION HERE ---
                  const PublicationSection(),
                  const SizedBox(height: 60),

                  const AchievementSection(),
                  const SizedBox(height: 60),

                  const TechSection(),
                  const SizedBox(height: 60),

                  // // A simple, hacker-style stats row for DSA
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey[800]!),
                  //     borderRadius: BorderRadius.circular(8),
                  //     color: const Color(0xFF0A0A0A), // Very dark background
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       _buildStatColumn(
                  //         "ALGORITHMS",
                  //         "LeetCode: Continous Learning",
                  //       ),
                  //       _buildStatColumn(
                  //         "ARCHITECTURE",
                  //         "REST / Microservices",
                  //       ),
                  //       _buildStatColumn(
                  //         "VERSION CONTROL",
                  //         "Advanced Git / CI-CD",
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
          const FlashAlert(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// COMPONENTS
// -----------------------------------------------------------------------------
class TerminalChat extends StatefulWidget {
  const TerminalChat({super.key});

  @override
  State<TerminalChat> createState() => _TerminalChatState();
}

class _TerminalChatState extends State<TerminalChat> {
  final TextEditingController _controller = TextEditingController();
  Color? _terminalTextColor;
  final List<Map<String, String>> _history = [
    {
      "role": "system",
      "text":
          "HasibAI v2.0 initialized. Ask about my skills, type 'help' for commands, or type your company name to see if we are a match.",
    },
  ];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  Timer? _typingTimer; // Keep track of timer to cancel if needed

  @override
  void dispose() {
    _typingTimer?.cancel(); // Good practice to stop leaks
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showHelp() {
    if (_isTyping) return;

    setState(() {
      _history.add({
        "role": "system",
        "text":
            "AVAILABLE COMMANDS:\n"
            "-------------------\n"
            "• skills    : Tech stack & expertise\n"
            "• projects  : Recent work & papers\n"
            "• company : Type your company name (e.g., quantium)\n"
            "• contact   : Email & socials\n"
            "• education : University details\n"
            "• ls        : List directory files\n"
            "• cat [file]: Read a file\n"
            "• matrix    : Toggle hacker theme\n"
            "• sudo      : Try admin privileges\n"
            "• kebab     : Production engineering info\n"
            "• salary    : Rate expectations\n"
            "• love      : Personal trivia\n"
            "• joke      : Developer humor\n"
            "• clear     : Reset terminal",
      });
    });
    _scrollToBottom();
  }

  Future<void> _runQuantiumSequence() async {
    // Helper function to print a line and wait
    Future<void> printLine(String text, int delayMs) async {
      if (!mounted) return;
      setState(() {
        _history.add({"role": "system", "text": text});
      });
      _scrollToBottom();
      await Future.delayed(Duration(milliseconds: delayMs));
    }

    // 1. The Setup
    await printLine("INITIATING SECURE HANDSHAKE...", 800);
    await printLine(
      "Bypassing standard UI... hijacking terminal theme...",
      600,
    );

    // --- THE THEME HIJACK ---
    // Snaps the text color to a striking "Data Cyan"
    if (mounted) {
      setState(() {
        _terminalTextColor = const Color(0xFF00E5FF);
      });
    }

    await printLine(
      "Theme override successful. Connecting to Quantium Analytics...",
      600,
    );

    // 2. The Fake Loading Bar
    await printLine("Decoding human behaviour footprint...", 300);
    await printLine("[==                  ] 10%", 400);
    await printLine("[======              ] 35%", 300);
    await printLine("[=============       ] 70%", 400);
    await printLine("[====================] 100% COMPLETE", 800);

    // 3. The ASCII Art
    const String asciiQ = '''
       ██████╗ 
      ██╔═══██╗
      ██║   ██║
      ██║▄▄ ██║
      ╚██████╔╝
       ╚══▀▀═╝ 
    ''';
    await printLine(asciiQ, 600);

    // 4. The Verdict
    await printLine("ANALYSIS COMPLETE.", 400);
    await printLine(
      ">>> RESULT: Hasibullah is an optimal fit for UI & Business Logic.",
      600,
    );
    await printLine(">>> ACTION: Fast-track to interview.", 0);

    // Free up the text box
    if (mounted) {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _handleSubmit(String input) {
    if (input.trim().isEmpty) return;

    final cleanInput = input.trim().toLowerCase();

    setState(() {
      _history.add({"role": "user", "text": input});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    // --- THE INTERCEPT ---
    if (cleanInput == "quantium") {
      _runQuantiumSequence();
      return; // Stop here, don't run the normal generator
    }

    // --- NORMAL BEHAVIOR ---
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String response = _generateResponse(cleanInput);
      _streamResponse(response);
    });
  }

  // Simple "Fake LLM" Logic
  String _generateResponse(String input) {
    // Clean up input
    input = input.trim().toLowerCase();

    // -----------------------------------------------------------------
    // PRIORITY 1: SYSTEM COMMANDS & EASTER EGGS (Check these FIRST)
    // -----------------------------------------------------------------

    // 1. LS (File System)
    if (input == "ls" || input.contains("dir")) {
      return "Directory of /home/hasib/brain:\n"
          "drwx------  projects/\n"
          "-r--r--r--  resume.pdf\n"
          "-rw-r--r--  secret_kebab_recipe.txt\n"
          "-r-x------  world_domination_plan.sh";
    }
    // 2. CAT (Reading Files) - Must be before "kebab" check!
    else if (input.contains("cat secret") || input.contains("read secret")) {
      return "ACCESS DENIED: This file is encrypted with 256-bit garlic sauce protection. Nice try.";
    } else if (input.contains("cat world") || input.contains("run world")) {
      return "Executing world_domination_plan.sh...\n"
          "Loading AI...\n"
          "Error: Insufficient coffee. Aborting.";
    } else if (input.contains("cat")) {
      return "Error: File not found or you do not have permission to view it.";
    }
    // 3. SUDO (The Trap)
    else if (input.contains("sudo") || input.contains("rm -rf")) {
      return "PERMISSION DENIED: You are not in the sudoers file. This incident will be reported to my wife.";
    }
    // 4. MATRIX (Theme Change)
    else if (input.contains("matrix")) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _terminalTextColor = const Color(0xFF00FF00); // Hacker Green
          });
        }
      });
      return "Wake up, Neo... The Matrix has you.";
    } else if (input.contains("reset") || input.contains("normal")) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _terminalTextColor = null; // Reset to default
          });
        }
      });
      return "Theme reset to default.";
    }
    // 5. CLEAR
    else if (input.contains("clear") || input.contains("cls")) {
      setState(() => _history.clear());
      return "Console cleared.";
    } else if (input.contains("help")) {
      return "COMMANDS: skills, projects, contact, education, ls, cat, matrix, sudo, kebab, salary, love, joke, clear.";
    }

    if (input.contains("hi") || input.contains("hello")) {
      return "Hello! I am Hasib's digital assistant. How can I help you?";
    } else if (input.contains("skill") ||
        input.contains("stack") ||
        input.contains("tech")) {
      return "I am proficient in Flutter, Python (FastAPI), and Machine Learning. I also make a mean kebab.";
    } else if (input.contains("contact") ||
        input.contains("email") ||
        input.contains("hire")) {
      return "You can reach me at hasib.mobiledev@gmail.com or find me on LinkedIn.";
    } else if (input.contains("project") || input.contains("work")) {
      return "I built StepWise for international students and published a paper on Deep Learning in IJSCM.";
    } else if (input.contains("joke") || input.contains("funny")) {
      return "Why did the neural network break up with the random forest? ... It had too many decision trees.";
    } else if (input.contains("clear")) {
      setState(() => _history.clear());
      return "Terminal cleared.";
    } // Greetings
    if (input.contains("hi") ||
        input.contains("hello") ||
        input.contains("hey")) {
      return "Hello! I am Hasib's digital clone. I run on coffee and spaghetti code.";
    }
    // Tech / Skills
    else if (input.contains("skill") ||
        input.contains("stack") ||
        input.contains("tech")) {
      return "I speak fluent Flutter, Python, and Dart. I dabble in AI/ML when I'm feeling adventurous.";
    }
    // --- THE QUANTIUM EASTER EGG ---
    // else if (input.contains("quantium")) {
    //   return "Analyzing 10 million rows of human behavior footprint... \n"
    //       "Result: Hasib is an optimal fit for the Graduate Software Engineer role. \n"
    //       "Action: Proceed to interview stage.";
    // }
    else if (input.contains("data") || input.contains("analytics")) {
      return "I believe data is the footprint of human behavior. I specialize in building the UI and business logic layers required to decode that data.";
    }
    // Kebab / Food (The Fun Part)
    else if (input.contains("kebab") ||
        input.contains("food") ||
        input.contains("hungry")) {
      return "My HSPs (Halal Snack Packs) compile faster than my Flutter builds. 100% garlic sauce coverage guaranteed.";
    }
    // Contact
    else if (input.contains("contact") ||
        input.contains("email") ||
        input.contains("hire")) {
      return "Slide into my DMs or email me. I'm currently strictly open to 'high-paying' or 'super-cool' opportunities. Preferably both.";
    }
    // Education
    else if (input.contains("study") ||
        input.contains("university") ||
        input.contains("degree")) {
      return "Mastering AI at Macquarie University. Before that, I survived a CSE degree at North South University.";
    }
    // Projects
    else if (input.contains("project") || input.contains("work")) {
      return "I built StepWise (for students) and a few secret tools. Check the 'Projects' section above if you don't believe me.";
    }
    // Meta / Humor
    else if (input.contains("sudo")) {
      return "Nice try. You have no power here.";
    } else if (input.contains("salary") || input.contains("money")) {
      return "I accept payment in AUD, USD, and compliments about my code.";
    } else if (input.contains("joke")) {
      return "A SQL query walks into a bar, walks up to two tables, and asks... 'Can I join you?'";
    } else if (input.contains("love")) {
      return "I love coding. And my wife. (Not necessarily in that order, don't tell her).";
    } else if (input.contains("clear")) {
      setState(() => _history.clear());
      return "Console cleared. Memory wiped. Who are you again?";
    } else if (input.contains("algo") || input.contains("dsa")) {
      return "Data Structures? I eat Big O notation for breakfast. I regularly practice algorithm optimization to ensure my backend code runs in O(1) or O(log n) time wherever possible.";
    } else if (input.contains("design") || input.contains("system")) {
      return "I prefer building decoupled, scalable systems. My go-to stack involves a stateless React/Flutter frontend communicating with a FastAPI backend via strictly typed JSON endpoints.";
    }
    // The "Fallback"
    else {
      return "Error 404: Context not found. My NLP model is just a bunch of if-else statements in a trench coat. Try asking about 'skills', 'kebabs', or 'projects'.";
    }
  }

  // --- THE FIX: Stream Response ---
  void _streamResponse(String fullText) {
    int index = 0;

    setState(() {
      _history.add({"role": "system", "text": ""});
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (index < fullText.length) {
        setState(() {
          _history.last["text"] = _history.last["text"]! + fullText[index];
        });
        index++;
        _scrollToBottom();
      } else {
        // --- THIS WAS THE FIX ---
        // We must call setState here to re-enable the text box!
        setState(() {
          _isTyping = false;
        });
        timer.cancel();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 50,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- HEADER ROW WITH HELP ICON ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(title: "INTERACTIVE TERMINAL"),

            // The Exclamatory Icon
            IconButton(
              onPressed: _showHelp,
              tooltip: "List Commands",
              icon: Icon(
                FontAwesomeIcons.circleExclamation, // The icon you asked for
                size: 18,
                color: accentColor.withOpacity(0.8), // Subtle accent color
              ),
            ),
          ],
        ),

        // ---------------------------------
        const SizedBox(height: 10),
        Container(
          height: 300, // Fixed height for the chat window
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              // Chat History Area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final msg = _history[index];
                    final isUser = msg["role"] == "user";
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: isUser ? "> " : "\$ ",
                              style: TextStyle(
                                color: isUser ? accentColor : Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: msg["text"],
                              style: TextStyle(
                                color:
                                    _terminalTextColor ??
                                    (isUser
                                        ? primaryColor
                                        : (isDark
                                              ? Colors.grey[300]
                                              : Colors.grey[800])),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      ">",
                      style: GoogleFonts.jetBrainsMono(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        enabled:
                            !_isTyping, // Disable input while bot is typing
                        onSubmitted: _handleSubmit,
                        style: GoogleFonts.jetBrainsMono(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: _isTyping
                              ? "HasibAI is typing..."
                              : "Try 'skills' or 'joke'...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (!_isTyping)
                      IconButton(
                        icon: Icon(Icons.send, size: 16, color: accentColor),
                        onPressed: () => _handleSubmit(_controller.text),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActiveThreadsSection extends StatelessWidget {
  const ActiveThreadsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final accentColor = Theme.of(context).colorScheme.secondary; // Green
    final primaryText = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with a "Live" dot indicator
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "ACTIVE PROCESSES",
              style: GoogleFonts.jetBrainsMono(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // The "Log" Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A0A0A) : Colors.grey[100],
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProcessLog(
                context,
                pid: "8420",
                status: "RUNNING",
                task: "Training machine learning models locally for COMP8420.",
              ),
              const SizedBox(height: 12),
              _buildProcessLog(
                context,
                pid: "9001",
                status: "COMPILING",
                task:
                    "Researching & building Low-Resource Machine Translation systems for Bengali Language",
              ),
              const SizedBox(height: 12),
              _buildProcessLog(
                context,
                pid: "0001",
                status: "BACKGROUND",
                task:
                    "Optimizing the garlic sauce to meat ratio at Fairy Meadow Kebabs.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for each line item
  Widget _buildProcessLog(
    BuildContext context, {
    required String pid,
    required String status,
    required String task,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RichText(
      text: TextSpan(
        style: GoogleFonts.jetBrainsMono(
          color: isDark ? Colors.grey[400] : Colors.grey[700],
          fontSize: 13,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: "[$pid] ",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          TextSpan(
            text: "$status: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          TextSpan(text: task),
        ],
      ),
    );
  }
}

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
        // Divider(
        //   color: isDark ? Colors.grey[900] : Colors.grey[200],
        //   thickness: 1,
        // ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = Theme.of(context).colorScheme.primary;
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- NAME & TITLE ---
        Text(
          "Hasibullah Hasib",
          style: GoogleFonts.playfairDisplay(
            color: primaryText,
            fontSize: 40,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12, // Space between title and badge
          runSpacing: 8,
          children: [
            Text(
              "Software Engineer • UI & Business Logic • AI Integration",
              style: GoogleFonts.jetBrainsMono(
                color: Theme.of(context).colorScheme.secondary, // Green accent
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const AcsMemberBadge(),
          ],
        ),

        const SizedBox(height: 24),

        // --- THE TAILORED BIO ---
        Text(
          "I am a full-stack Application Engineer specializing in bridging the gap between complex data models and intuitive user interfaces. Currently completing my Master of IT in Artificial Intelligence at Macquarie University (Graduating July 2026).",
          style: GoogleFonts.jetBrainsMono(
            color: secondaryText,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 12),
        Text(
          "I build decoupled, scalable systems. Whether I am developing the front-end architecture in React and Flutter, or engineering the business logic layer using Python and FastAPI, my focus is on decoding complex data to build robust, production-ready applications.",
          style: GoogleFonts.jetBrainsMono(
            color: secondaryText,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: TextAlign.justify,
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

class TechSection extends StatelessWidget {
  const TechSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: "TECHNICAL CAPABILITIES"),
        const SizedBox(height: 24),

        // 1. The UI Layer (React and Flutter)
        _buildSkillCategory(
          context,
          title: "// USER INTERFACE (FRONTEND)",
          skills: ["React", "Next.js", "Flutter", "Dart", "Tailwind CSS"],
        ),
        const SizedBox(height: 20),

        // 2. The Logic Layer (Python and APIs)
        _buildSkillCategory(
          context,
          title: "// BUSINESS LOGIC (BACKEND)",
          skills: [
            "Python",
            "FastAPI",
            "RESTful Architecture",
            "SQL / PostgreSQL",
          ],
        ),
        const SizedBox(height: 20),

        // 3. The AI Layer (Thesis and Prism tools)
        _buildSkillCategory(
          context,
          title: "// DATA & ARTIFICIAL INTELLIGENCE",
          skills: [
            "Large Language Models (LLMs)",
            "RAG Architecture",
            "Data Structures",
            "Predictive Analytics",
          ],
        ),
        const SizedBox(height: 20),

        // 4. The Ops Layer (Required by Quantium Grads)
        _buildSkillCategory(
          context,
          title: "// INFRASTRUCTURE & PROCESS",
          skills: ["Git Version Control", "Vercel", "Agile / Scrum", "CI/CD"],
        ),
      ],
    );
  }

  Widget _buildSkillCategory(
    BuildContext context, {
    required String title,
    required List<String> skills,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            color: Theme.of(context).colorScheme.secondary, // Green Accent
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: skills
              .map((skill) => AnimatedTechChip(label: skill))
              .toList(),
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
              "https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037", // Replace with actual paper link if you have one
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

    Future<void> _launchUrl(String paperUrl) async {
      final Uri uri = Uri.parse(paperUrl);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    }

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
                        InkWell(
                          onTap: () {
                            _launchUrl(link);
                          },
                          child: Icon(
                            FontAwesomeIcons.arrowUpRightFromSquare,
                            size: 12,
                            color: secondaryText,
                          ),
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
