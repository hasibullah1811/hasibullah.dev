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

class JourneyStop {
  const JourneyStop({
    required this.period,
    required this.place,
    required this.title,
    this.organisation,
    this.detail,
    this.bullets = const [],
  });

  final String period;
  final String place;
  final String title;
  final String? organisation;
  final String? detail;
  final List<String> bullets;
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
  final List<JourneyStop> journey;
  final List<CaseStudy> caseStudies;
  final List<Project> projects;
  final List<SkillGroup> skills;
  final List<Credential> credentials;
}
