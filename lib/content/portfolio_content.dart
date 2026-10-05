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
    tagline:
        'Software developer building practical apps in Flutter, Python and '
        'FastAPI.',
    // Shown on the page. The meta description in web/index.html keeps
    // "Wollongong" for search.
    location: 'NSW, Australia',
    openTo: 'Open to relocation and remote',
    status: 'Open to full-time roles',
    workRights: 'Full working rights (Subclass 485)',
    workRightsShort: 'Full working rights',
    closing:
        "I'm open to full-time roles in NSW, remote or somewhere new. Email "
        'is the quickest way to reach me.',
    email: 'hi@hasibullah.dev',
    linkedIn: 'https://www.linkedin.com/in/md-hasibullah-hasib-39a89a3a5/',
    github: 'https://github.com/hasibullah1811',
    leetCode: 'https://leetcode.com/u/hasibullah/',
    website: 'https://www.hasibullah.dev/',
    // Hidden until a corrected, redacted CV is approved. Then set to
    // 'cv/Hasibullah_Hasib_CV.pdf' and add the file under web/cv/.
    cvUrl: null,
  ),
  about: About(
    title: 'Things people actually use',
    text:
        "I'm a software developer who builds things people actually use. In "
        'Dhaka I made a COVID-19 help app that reached 2,000 users. In '
        'Australia I built an ERP system and staff apps that run across five '
        "restaurants, and now I'm building StepWise, an app for people "
        "settling into a new country, because I've made that move myself. I "
        'work mostly with Flutter, Python and FastAPI, and I hold a '
        "Master's in IT (AI) from Macquarie. I'm open to full-time roles, "
        'with full working rights in Australia.',
    metrics: [
      Metric(5, 'restaurant locations'),
      Metric(500, 'daily orders', upTo: 700),
      Metric(180, 'staff'),
      Metric(2000, 'users'),
    ],
  ),
  journey: Journey(
    title: 'From Bangladesh to Australia',
    origin: 'Dhaka, Bangladesh',
    destination: 'NSW, Australia',
    move: 'Moved to Australia',
    chapters: [
      JourneyChapter(
        name: 'Bangladesh',
        period: '2020 – 2024',
        // Runs alongside the entries below as a thin side bar.
        span: JourneySpan(
          startYear: 2021,
          period: '2021 – 2024',
          place: 'Dhaka, Bangladesh',
          // TODO(confirm): exact title — "Mobile Developer" or
          // "Software Developer".
          title: 'Software Developer (part-time)',
          organisation: 'Binary Craft',
          label: 'Binary Craft · part-time',
          bullets: [
            'Delivered 5 property and invoice management apps with Flutter '
                'and React, making invoice processing 20% faster for clients.',
            'Delivered software directly to international clients, which led '
                'to a development contract with Elements Bar & Grill in '
                'Australia.',
          ],
          stack: ['Flutter', 'React'],
        ),
        stops: [
          JourneyStop(
            year: 2020,
            period: '2020',
            place: 'Dhaka, Bangladesh',
            title: 'Built Helping Hand',
            detail:
                'A COVID-19 lockdown app connecting people who needed help '
                'with local volunteers.',
            metrics: [Metric(2000, 'active users')],
            stack: ['Flutter', 'Python', 'Flask', 'Firebase'],
          ),
          JourneyStop(
            year: 2021,
            period: '2021',
            place: 'Publication',
            title: 'Published research as primary author',
            detail:
                'Deep learning to aid prescription processing and inventory '
                'management for local pharmacies (IJSCM).',
          ),
          JourneyStop(
            year: 2023,
            period: '2023',
            place: 'Gulshan, Bangladesh',
            title: 'Taught programming fundamentals',
            organisation: 'New Horizons CLC',
            detail: 'Taught the foundations of programming.',
            metrics: [Metric(20, 'students', approximate: true)],
          ),
          JourneyStop(
            year: 2023,
            period: '2023',
            place: 'Dhaka, Bangladesh',
            title: 'BSc in Computer Science and Engineering',
            organisation: 'North South University',
          ),
        ],
      ),
      JourneyChapter(
        name: 'Australia',
        period: '2024 – now',
        stops: [
          JourneyStop(
            year: 2024,
            period: '2024 – 2026',
            place: 'Sydney, NSW',
            // TODO(confirm): exact title — "Full-Stack Developer" or
            // "Software Developer (Contract)".
            title: 'Software Developer',
            organisation: 'Elements Bar & Grill',
            metrics: [
              Metric(5, 'restaurant locations'),
              Metric(180, 'staff on clock-in'),
            ],
            bullets: [
              'Built an ERP system with a Python backend that centralised '
                  'inventory and logistics across every location.',
              'Built a Flutter iPad app that routes 500–700 daily orders '
                  'straight to kitchen printers, speeding up food preparation.',
              'Built a Flutter app with real-time, location-based clock-in and '
                  'clock-out for the whole team.',
            ],
            stack: ['Python', 'Flutter'],
          ),
          JourneyStop(
            year: 2025,
            period: 'Since Nov 2025',
            place: 'Side project',
            title: 'Building StepWise',
            detail:
                'A personal guide to settling in Australia, shaped by my own '
                'move. In private beta.',
            stack: ['Flutter', 'FastAPI', 'PostgreSQL'],
          ),
          JourneyStop(
            year: 2026,
            period: '2026',
            place: 'Sydney, NSW',
            title: 'Master of IT in Artificial Intelligence',
            organisation: 'Macquarie University',
          ),
          JourneyStop(
            year: 2026,
            period: 'Now',
            place: 'NSW, Australia',
            title: 'Looking for my next full-time role',
            detail: 'Open to relocation and remote.',
          ),
        ],
      ),
    ],
  ),
  caseStudies: [
    CaseStudy(
      name: 'StepWise',
      period: 'Since Nov 2025',
      status: 'In development · private beta',
      featured: true,
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
        'Building the FastAPI backend and PostgreSQL data model for the web '
            'beta first, so a mobile app can follow on the same backend.',
      ],
      stack: ['Flutter', 'FastAPI', 'PostgreSQL', 'Gemini on Vertex AI'],
      outcome: 'In private beta. Not yet publicly released.',
      // Not linked while in development / private beta.
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
      diagram: 'img/minima-architecture.png',
      diagramAlt:
          'Minima architecture: GitHub and Porkbun DNS deploy to Vercel; a '
          'Next.js 15 app routes to MDX lessons, whose interactive components '
          'run React state through d3-delaunay into native SVG.',
    ),
    CaseStudy(
      name: 'Prism',
      period: 'Jan 2026',
      status: 'Open source',
      // TODO(confirm): framing — this copy combines the old site's
      // description (vector matches, token attribution) and the repo's
      // (auditing text-splitting before embeddings).
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
      diagram: 'img/prism-architecture.png',
      diagramAlt:
          'Prism architecture: a React client on Vercel posts text to a '
          'FastAPI server on Render, which runs LangChain, Tiktoken and '
          'scikit-learn PCA and returns vectors, tokens and scores as JSON.',
    ),
  ],
  projects: [
    Project(
      name: 'LanDrop',
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
      detail: 'North South University · Dhaka, Bangladesh · 2023',
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
