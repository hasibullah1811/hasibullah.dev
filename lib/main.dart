import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'content/portfolio_content.dart';
import 'theme.dart';
import 'ui/portfolio_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Flutter web builds no accessibility tree until asked. Turning it on at
  // startup gives screen readers (and the DOM) real headings, text and links.
  SemanticsBinding.instance.ensureSemantics();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = portfolio.profile;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Must match <title> in web/index.html (checked by test/content_test.dart).
      title: '${profile.name} — ${profile.title}',
      theme: buildTheme(),
      home: const PortfolioPage(content: portfolio),
    );
  }
}
