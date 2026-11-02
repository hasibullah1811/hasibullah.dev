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
      expect(html, contains(profile.leetCode));
      expect(html, contains(profile.website));
    },
  );

  test('location is "NSW, Australia" on the page; Wollongong only in the '
      'meta description', () {
    expect(profile.location, 'NSW, Australia');
    for (final s in _allStrings()) {
      expect(s, isNot(contains('Wollongong')), reason: s);
    }
    final description = RegExp(
      r'<meta name="description" content="([^"]*)">',
    ).firstMatch(html)!.group(1)!;
    expect(description, contains('Wollongong'));
    expect(
      html.replaceFirst(description, '').contains('Wollongong'),
      isFalse,
      reason: 'Wollongong outside the meta description',
    );
  });

  test('about numbers match the facts', () {
    final shown = portfolio.about.metrics.map((m) => m.formatAt(1)).toList();
    expect(shown, ['5', '500–700', '180', '2,000']);
  });

  test('no unresolved or excluded content is published', () {
    final strings = _allStrings();
    for (final s in strings) {
      expect(s, isNot(contains('TODO')), reason: s);
      expect(s.toLowerCase(), isNot(contains('azure')), reason: s);
      expect(s, isNot(contains('gmail')), reason: s);
    }
  });

  test('StepWise is never described as released', () {
    final stepwise = portfolio.featured;
    expect(stepwise.name, 'StepWise');
    expect(stepwise.status, contains('private beta'));
    expect(stepwise.outcome, 'In private beta. Not yet publicly released.');
    expect(stepwise.links, isEmpty, reason: 'StepWise is not linked');
    final copy = [
      stepwise.tagline,
      stepwise.problem,
      stepwise.built,
      stepwise.outcome,
    ].join(' ').toLowerCase();
    for (final word in ['launched', 'released the', 'live demo', 'users']) {
      expect(copy, isNot(contains(word)), reason: word);
    }
  });

  test('projects stay compact', () {
    expect(portfolio.featured.stack.length, inInclusiveRange(3, 5));
    expect(portfolio.projects.map((p) => p.name), [
      'Helping Hand',
      'Minima',
      'Prism',
      'MedWay',
      'LanDrop',
    ]);
    for (final p in portfolio.projects) {
      expect(p.stack.length, lessThanOrEqualTo(3), reason: p.name);
      expect(p.bullets.length, lessThanOrEqualTo(2), reason: p.name);
    }
  });

  group('research', () {
    final research = portfolio.research;
    final projects = research.universityProjects;

    test('only the IJSCM paper is published', () {
      expect(research.published, hasLength(1));
      expect(
        research.published.single.detail,
        contains('International Journal of Supply Chain Management'),
      );
    });

    test('university projects are never called publications', () {
      expect(research.projectTag, 'Unpublished · University project');
      for (final p in projects) {
        final copy = [
          p.title,
          p.source,
          p.summary,
          p.abstract,
          ?p.coAuthors,
        ].join(' ').toLowerCase();
        for (final word in [
          'publication',
          'published',
          'journal',
          'conference',
          'peer review',
          'doi',
        ]) {
          expect(copy, isNot(contains(word)), reason: '${p.slug}: $word');
        }
      }
    });

    test('no student IDs or email addresses', () {
      for (final p in projects) {
        final copy = [p.title, p.source, p.summary, p.abstract, ?p.coAuthors];
        for (final s in copy) {
          expect(s, isNot(contains('@')), reason: s);
          expect(s, isNot(matches(RegExp(r'\d{7,}'))), reason: s);
        }
      }
    });

    test('slugs are the approved, permanent ones', () {
      expect(projects.map((p) => p.slug), [
        'bengali-text-generation-bloom-lora.pdf',
        'bengali-lora-bloom-adaptation.pdf',
        'rag-medical-translation-bengali.pdf',
      ]);
      final doc = File('docs/papers.md').readAsStringSync();
      for (final p in projects) {
        expect(
          doc,
          contains('https://www.hasibullah.dev/${p.slug}'),
          reason: p.slug,
        );
      }
    });

    test('a PDF is linked only once its redacted file is in web/', () {
      for (final p in projects) {
        if (p.pdfUrl case final url?) {
          expect(url, p.slug);
          expect(File('web/$url').existsSync(), isTrue, reason: url);
        }
      }
      // Needs the supervisor's consent first.
      expect(
        projects.firstWhere((p) => p.slug.contains('adaptation')).pdfUrl,
        isNull,
      );
    });

    test('original PDFs can never be committed', () {
      final ignore = File('.gitignore').readAsStringSync();
      expect(ignore, contains('/assets/paper/'));
    });
  });

  test('journey entries are chronological within each chapter', () {
    for (final chapter in portfolio.journey.chapters) {
      final years = chapter.stops.map((s) => s.year).toList();
      expect(years, [...years]..sort(), reason: chapter.name);
    }
  });

  test('every linked local file exists', () {
    final local = [
      ...portfolio.featured.links.map((l) => l.url),
      for (final p in portfolio.projects) ...p.links.map((l) => l.url),
      for (final p in portfolio.research.universityProjects) ?p.pdfUrl,
      ?profile.cvUrl,
    ].where((u) => !u.contains(':'));
    for (final path in local) {
      expect(File('web/$path').existsSync(), isTrue, reason: path);
    }
    if (portfolio.featured.image case final image?) {
      expect(File(image).existsSync(), isTrue, reason: image);
    }
  });
}

List<String> _allStrings() {
  final p = portfolio.profile;
  return [
    p.name,
    p.title,
    p.tagline,
    p.location,
    p.openTo,
    p.status,
    p.workRights,
    p.workRightsShort,
    p.closing,
    p.email,
    portfolio.about.title,
    portfolio.about.text,
    ...portfolio.about.metrics.map((m) => m.label),
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
        ...span.stack,
      ],
      for (final s in chapter.stops) ...[
        s.period,
        s.place,
        s.title,
        ?s.organisation,
        ?s.detail,
        ...s.bullets,
        ...s.metrics.map((m) => m.label),
        ...s.stack,
      ],
    ],
    for (final c in [portfolio.featured]) ...[
      c.name,
      c.period,
      c.status,
      c.tagline,
      c.problem,
      c.built,
      c.outcome,
      ...c.stack,
      ...c.links.map((l) => l.label),
      ?c.imageAlt,
    ],
    for (final pr in portfolio.projects) ...[
      pr.name,
      pr.period,
      ?pr.status,
      pr.description,
      ...pr.bullets,
      ...pr.details,
      ...pr.stack,
      ...pr.links.map((l) => l.label),
    ],
    for (final g in portfolio.skills) ...[g.name, ...g.items],
    for (final c in portfolio.education) ...[c.title, c.detail],
    for (final p in portfolio.research.published) ...[
      p.title,
      p.detail,
      p.link.label,
    ],
    for (final p in portfolio.research.universityProjects) ...[
      p.title,
      p.source,
      p.summary,
      p.abstract,
      ?p.coAuthors,
    ],
    portfolio.research.projectTag,
    portfolio.research.pdfOnRequest,
    portfolio.membership,
  ];
}
