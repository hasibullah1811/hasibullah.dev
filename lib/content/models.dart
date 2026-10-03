// Plain data types for the portfolio content. No widgets here.

class Profile {
  const Profile({
    required this.name,
    required this.title,
    required this.summary,
    required this.location,
    required this.openTo,
    required this.status,
    required this.workRights,
    required this.coreStack,
    required this.email,
    required this.linkedIn,
    required this.github,
    required this.website,
    this.cvUrl,
  });

  final String name;
  final String title;
  final String summary;
  final String location;
  final String openTo;
  final String status;
  final String workRights;
  final List<String> coreStack;
  final String email;
  final String linkedIn;
  final String github;
  final String website;

  /// Path to the public, redacted CV. The CV button is hidden while null.
  final String? cvUrl;
}

class LinkItem {
  const LinkItem(this.label, this.url);

  final String label;
  final String url;
}

/// A number that counts up when its journey card appears.
class Metric {
  const Metric(this.value, this.label, {this.approximate = false});

  final int value;
  final String label;

  /// Shown with a leading "~", e.g. "~20 students".
  final bool approximate;

  String format(int current) =>
      '${approximate ? '~' : ''}${formatThousands(current)}';
}

String formatThousands(int value) => value.toString().replaceAllMapped(
  RegExp(r'\B(?=(\d{3})+(?!\d))'),
  (_) => ',',
);

class JourneyStop {
  const JourneyStop({
    required this.year,
    required this.period,
    required this.place,
    required this.title,
    this.organisation,
    this.detail,
    this.bullets = const [],
    this.metrics = const [],
  });

  /// Sort key. Entries are shown in chronological order within a chapter.
  final int year;
  final String period;
  final String place;
  final String title;
  final String? organisation;
  final String? detail;
  final List<String> bullets;
  final List<Metric> metrics;
}

/// Work that ran alongside a chapter's other entries (shown as a side bar).
class JourneySpan {
  const JourneySpan({
    required this.startYear,
    required this.period,
    required this.place,
    required this.title,
    required this.organisation,
    required this.label,
    this.bullets = const [],
  });

  final int startYear;
  final String period;
  final String place;
  final String title;
  final String organisation;

  /// Short text written along the side bar.
  final String label;
  final List<String> bullets;

  /// On narrow screens the span is shown as an ordinary entry.
  JourneyStop asStop() => JourneyStop(
    year: startYear,
    period: period,
    place: place,
    title: title,
    organisation: organisation,
    bullets: bullets,
  );
}

class JourneyChapter {
  const JourneyChapter({
    required this.name,
    required this.period,
    required this.stops,
    this.span,
  });

  final String name;
  final String period;
  final List<JourneyStop> stops;
  final JourneySpan? span;
}

class Journey {
  const Journey({
    required this.title,
    required this.origin,
    required this.destination,
    required this.move,
    required this.chapters,
  });

  final String title;

  /// Labels at the two ends of the route line.
  final String origin;
  final String destination;

  /// Marker between the chapters.
  final String move;
  final List<JourneyChapter> chapters;
}

class CaseStudy {
  const CaseStudy({
    required this.name,
    required this.period,
    required this.tagline,
    required this.problem,
    required this.work,
    required this.stack,
    required this.outcome,
    this.status,
    this.links = const [],
    this.image,
    this.imageAlt,
  });

  final String name;
  final String period;
  final String tagline;
  final String problem;
  final List<String> work;
  final List<String> stack;
  final String outcome;
  final String? status;
  final List<LinkItem> links;
  final String? image;
  final String? imageAlt;
}

class Project {
  const Project({
    required this.name,
    required this.period,
    required this.description,
    required this.stack,
    this.links = const [],
  });

  final String name;
  final String period;
  final String description;
  final List<String> stack;
  final List<LinkItem> links;
}

class SkillGroup {
  const SkillGroup(this.name, this.items);

  final String name;
  final List<String> items;
}

class Credential {
  const Credential({
    required this.kind,
    required this.title,
    required this.detail,
    this.link,
  });

  final String kind;
  final String title;
  final String detail;
  final LinkItem? link;
}

class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.journey,
    required this.caseStudies,
    required this.projects,
    required this.skills,
    required this.credentials,
  });

  final Profile profile;
  final Journey journey;
  final List<CaseStudy> caseStudies;
  final List<Project> projects;
  final List<SkillGroup> skills;
  final List<Credential> credentials;
}
