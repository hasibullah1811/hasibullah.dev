// Plain data types for the portfolio content. No widgets here.

class Profile {
  const Profile({
    required this.name,
    required this.title,
    required this.tagline,
    required this.location,
    required this.openTo,
    required this.status,
    required this.workRights,
    required this.workRightsShort,
    required this.closing,
    required this.email,
    required this.linkedIn,
    required this.github,
    required this.leetCode,
    required this.website,
    this.cvUrl,
  });

  final String name;

  /// Used in the page title and meta tags.
  final String title;

  /// The line under the name in the hero.
  final String tagline;
  final String location;
  final String openTo;
  final String status;
  final String workRights;

  /// Shown in the hero's availability line.
  final String workRightsShort;

  /// The one line in the contact section.
  final String closing;
  final String email;
  final String linkedIn;
  final String github;
  final String leetCode;
  final String website;

  /// Path to the public, redacted CV. The CV button is hidden while null.
  final String? cvUrl;
}

class LinkItem {
  const LinkItem(this.label, this.url);

  final String label;
  final String url;
}

/// A number that counts up when its card or section appears.
class Metric {
  const Metric(this.value, this.label, {this.approximate = false, this.upTo});

  final int value;
  final String label;

  /// Shown with a leading "~", e.g. "~20 students".
  final bool approximate;

  /// Upper end of a range, e.g. 700 in "500–700 daily orders".
  final int? upTo;

  /// The text at [t] of the count-up, from 0 to 1.
  String formatAt(double t) {
    final low = formatThousands((value * t).round());
    final upTo = this.upTo;
    final high = upTo == null ? '' : '–${formatThousands((upTo * t).round())}';
    return '${approximate ? '~' : ''}$low$high';
  }
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
    this.stack = const [],
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
  final List<String> stack;
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
    this.stack = const [],
  });

  final int startYear;
  final String period;
  final String place;
  final String title;
  final String organisation;

  /// Short text written along the side bar.
  final String label;
  final List<String> bullets;
  final List<String> stack;

  /// On narrow screens the span is shown as an ordinary entry.
  JourneyStop asStop() => JourneyStop(
    year: startYear,
    period: period,
    place: place,
    title: title,
    organisation: organisation,
    bullets: bullets,
    stack: stack,
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

/// The one featured project, shown as a larger block with a screenshot.
class CaseStudy {
  const CaseStudy({
    required this.name,
    required this.period,
    required this.status,
    required this.tagline,
    required this.problem,
    required this.built,
    required this.outcome,
    required this.stack,
    this.links = const [],
    this.image,
    this.imageAlt,
  });

  final String name;
  final String period;
  final String status;
  final String tagline;

  /// One line each.
  final String problem;
  final String built;
  final String outcome;

  /// Three to five tags.
  final List<String> stack;
  final List<LinkItem> links;
  final String? image;
  final String? imageAlt;
}

/// A compact project row.
class Project {
  const Project({
    required this.name,
    required this.period,
    required this.description,
    required this.stack,
    this.status,
    this.bullets = const [],
    this.details = const [],
    this.links = const [],
  });

  final String name;
  final String period;
  final String? status;

  /// One line on what it does.
  final String description;

  /// Three tags.
  final List<String> stack;

  /// At most two short bullets, usually none (test/content_test.dart).
  final List<String> bullets;

  /// Shown behind a "Details" toggle that starts closed: the problem, then
  /// the key point.
  final List<String> details;
  final List<LinkItem> links;
}

class SkillGroup {
  const SkillGroup(this.name, this.items);

  final String name;
  final List<String> items;
}

class Credential {
  const Credential({required this.title, required this.detail});

  final String title;
  final String detail;
}

/// A peer-reviewed, published paper.
class Publication {
  const Publication({
    required this.title,
    required this.detail,
    required this.link,
  });

  final String title;

  /// Journal, issue, date and role.
  final String detail;
  final LinkItem link;
}

/// An unpublished paper written for a university course. Never described
/// as a publication.
class ResearchProject {
  const ResearchProject({
    required this.title,
    required this.source,
    required this.summary,
    required this.abstract,
    required this.slug,
    this.coAuthors,
    this.pdfUrl,
  });

  final String title;

  /// Institution, course and year, as printed on the PDF.
  final String source;

  /// One plain-English line.
  final String summary;

  /// The short summary shown behind the "Abstract" toggle.
  final String abstract;

  /// The approved, permanent file name: `https://www.hasibullah.dev/<slug>`.
  /// Listed in docs/papers.md.
  final String slug;

  /// Shown as "With ...". Names only, as written on the PDF.
  final String? coAuthors;

  /// Path under web/ to the redacted public edition. While null the page
  /// says "PDF available on request".
  final String? pdfUrl;
}

class Research {
  const Research({
    required this.published,
    required this.universityProjects,
    required this.projectTag,
    required this.pdfOnRequest,
  });

  final List<Publication> published;
  final List<ResearchProject> universityProjects;

  /// The small tag on every university project.
  final String projectTag;

  /// Shown instead of the PDF link while a project's pdfUrl is null.
  final String pdfOnRequest;
}

class About {
  const About({required this.title, required this.text, required this.metrics});

  final String title;
  final String text;
  final List<Metric> metrics;
}

class PortfolioContent {
  const PortfolioContent({
    required this.profile,
    required this.about,
    required this.journey,
    required this.featured,
    required this.projects,
    required this.skills,
    required this.education,
    required this.research,
    required this.membership,
  });

  final Profile profile;
  final About about;
  final Journey journey;
  final CaseStudy featured;
  final List<Project> projects;
  final List<SkillGroup> skills;
  final List<Credential> education;
  final Research research;

  /// One small line after the research list.
  final String membership;
}
