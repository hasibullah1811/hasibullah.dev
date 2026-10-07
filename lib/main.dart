import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'content/portfolio_content.dart';
import 'theme.dart';
import 'ui/portfolio_page.dart';
import 'ui/theme_controller.dart';
import 'ui/theme_transition.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter web builds no accessibility tree until asked. Turning it on at
  // startup gives screen readers (and the DOM) real headings, text and links.
  SemanticsBinding.instance.ensureSemantics();
  runApp(PortfolioApp(themeController: ThemeController.fromBrowser()));
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final profile = portfolio.profile;
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // Must match <title> in web/index.html (checked by
        // test/content_test.dart).
        title: '${profile.name} — ${profile.title}',
        theme: buildTheme(AppColors.light),
        darkTheme: buildTheme(AppColors.dark),
        themeMode: themeController.mode,
        themeAnimationDuration: themeController.themeAnimation,
        builder: (context, child) => ThemeTransitionHost(
          controller: themeController,
          textColumnWidth: contentMaxWidth,
          child: child!,
        ),
        home: const PortfolioPage(content: portfolio),
      ),
    );
  }
}
