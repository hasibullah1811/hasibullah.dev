// All site copy lives here. Edit this file to change what the site says;
// UI code reads from it and never hard-codes content.
//
// Facts must match docs/facts.md. Anything marked TODO(confirm) there is
// either left out below or shown only in the form both sources agree on.

import 'models.dart';

const portfolio = PortfolioContent(
  profile: Profile(
    name: 'Hasibullah Hasib',
    title: 'Software Developer',
    summary:
        'I build production software end to end: an ERP and Flutter apps '
        'that run five restaurant locations in Sydney, and open-source tools '
        'that make RAG and machine learning easier to see.',
    location: 'Wollongong, NSW',
    openTo: 'Open to relocation and remote',
    status: 'Open to full-time roles',
    workRights: 'Full working rights (Subclass 485)',
    coreStack: ['Flutter', 'Python', 'React', 'PostgreSQL'],
    email: 'hi@hasibullah.dev',
    linkedIn: 'https://www.linkedin.com/in/md-hasibullah-hasib-39a89a3a5/',
    github: 'https://github.com/hasibullah1811',
    website: 'https://www.hasibullah.dev/',
    // Hidden until a corrected, redacted CV is approved. Then set to
    // 'cv/Hasibullah_Hasib_CV.pdf' and add the file under web/cv/.
    cvUrl: null,
  ),
  journey: [
    JourneyStop(
      period: '2020',
      place: 'Dhaka, Bangladesh',
      title: 'Built Helping Hand',
      detail:
          'A COVID-19 lockdown app connecting people who needed help with '
          'local volunteers. It grew to 2,000 active users.',
    ),
    JourneyStop(
      period: '2021 – 2024',
      place: 'Dhaka, Bangladesh',
      // TODO(confirm): exact title — "Mobile Developer" or "Software Developer".
      title: 'Software Developer (part-time)',
      organisation: 'Binary Craft',
      bullets: [
        'Delivered 5 property and invoice management apps with Flutter and '
            'React, making invoice processing 20% faster for clients.',
        'Delivered software directly to international clients, which led '
            'to a development contract with Elements Bar & Grill in Australia.',
      ],
    ),
    JourneyStop(
      period: '2021',
      place: 'Publication',
      title: 'Published research as primary author',
      detail:
          'Deep learning to aid prescription processing and inventory '
          'management for local pharmacies (IJSCM).',
    ),
    JourneyStop(
      period: '2023',
      place: 'Gulshan, Bangladesh',
      title: 'Taught programming fundamentals',
      organisation: 'New Horizons CLC',
      detail: 'Taught about 20 students the foundations of programming.',
    ),
    JourneyStop(
      // TODO(confirm): start month — June or July 2024.
      period: '2024 – Jul 2026',
      place: 'Sydney, NSW',
      // TODO(confirm): exact title — "Full-Stack Developer" or
      // "Software Developer (Contract)".
      title: 'Software Developer',
      organisation: 'Elements Bar & Grill',
      bullets: [
        'Built an ERP system with a Python backend that centralised inventory '
            'and logistics across 5 restaurant locations.',
        'Built a Flutter iPad app that routes 500–700 daily orders straight '
            'to kitchen printers, speeding up food preparation.',
        'Built a Flutter app with real-time, location-based clock-in and '
            'clock-out that tracks hours for 180 staff.',
      ],
    ),
    JourneyStop(
      period: 'Since Nov 2025',
      place: 'Side project',
      title: 'Building StepWise',
      detail:
          'A personal guide to settling in Australia, shaped by my own move. '
          'In private beta.',
    ),
    JourneyStop(
      period: '2026',
      place: 'Sydney, NSW',
      title: 'Master of IT in Artificial Intelligence',
      organisation: 'Macquarie University',
    ),
    JourneyStop(
      period: 'Now',
      place: 'Wollongong, NSW',
      title: 'Looking for my next full-time role',
      detail: 'Open to relocation and remote.',
    ),
  ],
  caseStudies: [
    CaseStudy(
      name: 'StepWise',
      period: 'Since Nov 2025',
      status: 'In development · private beta',
      tagline: 'A personal guide to settling in Australia.',
      problem:
          'When I moved to Australia, working out visas and jobs meant a lot '
          'of confused Googling. StepWise is the tool I wanted then: describe '
          'your situation and get a clear, step-by-step plan.',
      work: [
        'Designing and building the whole product myself, from the Flutter '
            'front end to the API and database.',
        'Turning a person\'s situation into a personalised AI action plan '
            'that covers visas and jobs.',
        'Shaping the REST API and PostgreSQL data model for the web beta '
            'first, so a mobile app can follow on the same backend.',
      ],
      // TODO(confirm): backend framework (Flask, AWS API Gateway, or both)
      // and AI provider. Only agreed parts are listed.
      stack: ['Flutter', 'REST APIs', 'PostgreSQL'],
      outcome: 'In private beta. Not yet publicly released.',
      // TODO(confirm): link https://www.thestepwise.com/ during the beta?
      links: [],
      image: 'assets/images/stepwise.jpg',
      imageAlt:
          'StepWise landing page: "Your Personal Guide to Settling in '
          'Australia", with a prompt box asking for the steps to get a 485 '
          'Graduate Visa.',
    ),
    CaseStudy(
      name: 'Minima',
      period: 'Ongoing',
      status: 'Open source',
      tagline: 'The invisible mechanics of machine learning, made visible.',
      problem:
          'Machine learning is usually taught as formulas and black boxes, '
          'which makes it hard to build intuition for what an algorithm is '
          'actually doing.',
      work: [
        'Building an interactive curriculum where each lesson pairs readable '
            'MDX with sandboxes that run in the browser.',
        'Letting readers change data, hyperparameters and geometry directly '
            'and watch the algorithm respond.',
      ],
      stack: ['TypeScript', 'Next.js', 'MDX', 'd3'],
      outcome: 'Live and in active development.',
      links: [
        LinkItem('Live site', 'https://www.tryminima.com/'),
        LinkItem('Code', 'https://github.com/hasibullah1811/minima'),
        LinkItem('Architecture', 'img/minima-architecture.png'),
      ],
    ),
    CaseStudy(
      name: 'Prism',
      period: 'Jan 2026',
      status: 'Open source',
      tagline: 'Opening the black box of RAG pipelines.',
      problem:
          'Chunking and retrieval choices make or break a RAG system, but they '
          'are hard to see, especially before you pay for embeddings.',
      work: [
        'Built a React app with a Python (FastAPI) backend that shows how '
            'text is split, embedded and matched.',
        'Added scatter plots and map views to track vector matches, and JSON '
            'export of token attribution data for offline analysis.',
      ],
      stack: ['React', 'Python', 'FastAPI', 'LangChain', 'scikit-learn'],
      outcome: 'Open source with a public live demo.',
      links: [
        LinkItem('Live demo', 'https://prism-xi-three.vercel.app/'),
        LinkItem('Code', 'https://github.com/hasibullah1811/prism'),
        LinkItem('Architecture', 'img/prism-architecture.png'),
      ],
    ),
  ],
  projects: [
    Project(
      name: 'LandDrop',
      period: 'May 2026',
      description:
          'Zero-configuration file sharing and media streaming on your local '
          'network, with real-time sync, HTTP video streaming and a TV-friendly '
          'interface.',
      stack: ['Python', 'JavaScript'],
      links: [LinkItem('Code', 'https://github.com/hasibullah1811/landrop')],
    ),
    Project(
      name: 'MedWay',
      period: 'Mar 2021',
      description:
          'A medicine delivery app for Bangladesh, built end to end from the '
          'mobile app to launch.',
      stack: ['Flutter', 'Dart'],
      links: [LinkItem('Code', 'https://github.com/hasibullah1811/medway')],
    ),
    Project(
      name: 'Helping Hand',
      period: 'Jul 2020',
      description:
          'A COVID-19 lockdown app matching people who needed help with local '
          'volunteers. 2,000 active users and 50+ help requests a day.',
      stack: ['Flutter', 'Python', 'Flask', 'Firebase'],
      links: [
        LinkItem(
          'Code',
          'https://github.com/hasibullah1811/covid-19-helping-hand-find-help-nearby',
        ),
      ],
    ),
  ],
  skills: [
    SkillGroup('Languages', [
      'Java',
      'Python',
      'TypeScript / JavaScript',
      'Dart',
      'SQL',
      'Kotlin',
      'C++',
    ]),
    SkillGroup('Backend & data', [
      'REST APIs',
      'PostgreSQL',
      'MySQL',
      'Flask',
      'FastAPI',
      'NestJS',
      'ORMs',
      'Firebase',
    ]),
    SkillGroup('Frontend & mobile', ['Flutter', 'React']),
    SkillGroup('AI & ML', [
      'RAG',
      'Vector databases',
      'LangChain',
      'PyTorch',
      'Pandas',
      'NumPy',
    ]),
    SkillGroup('Delivery & practices', [
      'Git & GitHub',
      'CI/CD',
      'Test-driven development',
      'Secure development',
      'Vercel',
      'Railway',
      'Linux',
    ]),
  ],
  credentials: [
    Credential(
      kind: 'Education',
      title: 'Master of Information Technology in Artificial Intelligence',
      detail: 'Macquarie University · Sydney, NSW · 2026',
    ),
    Credential(
      kind: 'Education',
      title: 'Bachelor of Science in Computer Science and Engineering',
      // TODO(confirm): graduation year (2023 or 2024) before adding it.
      detail: 'North South University · Dhaka, Bangladesh',
    ),
    Credential(
      kind: 'Publication',
      title:
          'Deep learning to aid prescription processing & inventory management '
          'for local pharmacies through smartphone application',
      detail:
          'International Journal of Supply Chain Management, Vol. 10, No. 4, '
          'Aug 2021 · Primary author',
      link: LinkItem(
        'Read the paper',
        'https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037',
      ),
    ),
    Credential(
      kind: 'Membership',
      title: 'Australian Computer Society (ACS)',
      detail: 'Member',
    ),
  ],
);
