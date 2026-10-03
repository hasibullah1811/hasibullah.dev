import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hasib_website/content/portfolio_content.dart';

// Guards against the drift the old site had: the page, the HTML meta tags and
// the manifest each claiming a different title.
void main() {
  final profile = portfolio.profile;
  final html = File('web/index.html').readAsStringSync();
  final manifest =
      jsonDecode(File('web/manifest.json').readAsStringSync())
          as Map<String, dynamic>;
  final pageTitle = '${profile.name} — ${profile.title}';

  test('title is Software Developer everywhere', () {
    expect(profile.title, 'Software Developer');
    expect(html, contains('<title>$pageTitle</title>'));
    expect(html, contains('property="og:title" content="$pageTitle"'));
    expect(html, contains('name="twitter:title" content="$pageTitle"'));
    expect(manifest['name'], pageTitle);
    expect(manifest['description'] as String, contains(profile.title));
  });

  test(
    'index.html carries the key facts for crawlers and the loading state',
    () {
      expect(html, contains(profile.location));
      expect(html, contains(profile.workRights));
      expect(html, contains(profile.status));
      expect(html, contains('mailto:${profile.email}'));
      expect(html, contains(profile.linkedIn));
      expect(html, contains(profile.website));
    },
  );

  test('no unresolved or excluded content is published', () {
    final strings = _allStrings();
    for (final s in strings) {
      expect(s, isNot(contains('TODO')), reason: s);
      expect(s.toLowerCase(), isNot(contains('azure')), reason: s);
      expect(s, isNot(contains('gmail')), reason: s);
    }
  });

  test('StepWise is never described as released', () {
    final stepwise = portfolio.caseStudies.firstWhere(
      (c) => c.name == 'StepWise',
    );
    expect(stepwise.status, contains('private beta'));
    final copy = [
      stepwise.tagline,
      stepwise.problem,
      stepwise.outcome,
      ...stepwise.work,
    ].join(' ').toLowerCase();
    for (final word in ['launched', 'released the', 'live demo', 'users']) {
      expect(copy, isNot(contains(word)), reason: word);
    }
  });

  test('journey entries are chronological within each chapter', () {
    for (final chapter in portfolio.journey.chapters) {
      final years = chapter.stops.map((s) => s.year).toList();
      expect(years, [...years]..sort(), reason: chapter.name);
    }
  });

  test('every linked local file exists', () {
    final local = [
      for (final c in portfolio.caseStudies) ...c.links.map((l) => l.url),
      ?profile.cvUrl,
    ].where((u) => !u.contains(':'));
    for (final path in local) {
      expect(File('web/$path').existsSync(), isTrue, reason: path);
    }
    for (final c in portfolio.caseStudies) {
      if (c.image case final image?) {
        expect(File(image).existsSync(), isTrue, reason: image);
      }
    }
  });
}

List<String> _allStrings() {
  final p = portfolio.profile;
  return [
    p.name,
    p.title,
    p.summary,
    p.location,
    p.openTo,
    p.status,
    p.workRights,
    p.email,
    ...p.coreStack,
    portfolio.journey.title,
    portfolio.journey.origin,
    portfolio.journey.destination,
    portfolio.journey.move,
    for (final chapter in portfolio.journey.chapters) ...[
      chapter.name,
      chapter.period,
      if (chapter.span case final span?) ...[
        span.period,
        span.place,
        span.title,
        span.organisation,
        span.label,
        ...span.bullets,
      ],
      for (final s in chapter.stops) ...[
        s.period,
        s.place,
        s.title,
        ?s.organisation,
        ?s.detail,
        ...s.bullets,
        ...s.metrics.map((m) => m.label),
      ],
    ],
    for (final c in portfolio.caseStudies) ...[
      c.name,
      c.period,
      c.tagline,
      c.problem,
      c.outcome,
      ?c.status,
      ...c.work,
      ...c.stack,
      ...c.links.map((l) => l.label),
    ],
    for (final pr in portfolio.projects) ...[
      pr.name,
      pr.period,
      pr.description,
      ...pr.stack,
    ],
    for (final g in portfolio.skills) ...[g.name, ...g.items],
    for (final c in portfolio.credentials) ...[c.kind, c.title, c.detail],
  ];
}
