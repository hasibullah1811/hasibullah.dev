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
      Metric(5, 'locations'),
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
  featured: CaseStudy(
    name: 'StepWise',
    period: 'Since Nov 2025',
    status: 'In development · private beta',
    tagline: 'A personal guide to settling in Australia.',
    problem:
        'When I moved to Australia, working out visas and jobs meant a lot of '
        'confused Googling.',
    built:
        'The whole product on my own: a Flutter front end, a FastAPI and '
        'PostgreSQL backend, and an AI step that turns a person\'s situation '
        'into a step-by-step plan for visas and jobs.',
    outcome: 'In private beta. Not yet publicly released.',
    stack: ['Flutter', 'FastAPI', 'PostgreSQL', 'Gemini on Vertex AI'],
    // Not linked while in development / private beta.
    links: [],
    image: 'assets/images/stepwise.jpg',
    imageAlt:
        'StepWise landing page: "Your Personal Guide to Settling in '
        'Australia", with a prompt box asking for the steps to get a 485 '
        'Graduate Visa.',
  ),
  projects: [
    Project(
      name: 'Helping Hand',
      period: 'Jul 2020',
      description:
          'A COVID-19 lockdown app matching people who needed help with local '
          'volunteers. 2,000 active users and 50+ help requests a day.',
      stack: ['Flutter', 'Flask', 'Firebase'],
      // TODO(confirm): which repo — this one (linked from the resume) or
      // Helping-hand-CSE115-Project.
      links: [
        LinkItem(
          'Code',
          'https://github.com/hasibullah1811/covid-19-helping-hand-find-help-nearby',
        ),
      ],
    ),
    Project(
      name: 'Minima',
      period: 'Ongoing',
      status: 'Open source',
      description:
          'An interactive machine learning course: readable lessons with '
          'sandboxes that run in the browser.',
      stack: ['TypeScript', 'Next.js', 'MDX'],
      details: [
        'Machine learning is usually taught as formulas and black boxes, '
            'which makes it hard to build intuition for what an algorithm is '
            'actually doing.',
        'Readers change data, hyperparameters and geometry directly and '
            'watch the algorithm respond.',
      ],
      links: [
        LinkItem('Live site', 'https://www.tryminima.com/'),
        LinkItem('Code', 'https://github.com/hasibullah1811/minima'),
        LinkItem('Architecture', 'img/minima-architecture.png'),
      ],
    ),
    Project(
      name: 'Prism',
      period: 'Jan 2026',
      status: 'Open source',
      // TODO(confirm): framing — this copy combines the old site's
      // description (vector matches, token attribution) and the repo's
      // (auditing text-splitting before embeddings).
      description:
          'A visual tool that shows how a RAG pipeline splits, embeds and '
          'matches text.',
      stack: ['React', 'FastAPI', 'LangChain'],
      details: [
        'Chunking and retrieval choices make or break a RAG system, but they '
            'are hard to see, especially before you pay for embeddings.',
        'Scatter plots and map views track vector matches, and token '
            'attribution data exports as JSON for offline analysis.',
      ],
      links: [
        LinkItem('Live demo', 'https://prism-xi-three.vercel.app/'),
        LinkItem('Code', 'https://github.com/hasibullah1811/prism'),
        LinkItem('Architecture', 'img/prism-architecture.png'),
      ],
    ),
    Project(
      name: 'MedWay',
      period: 'Mar 2021',
      description:
          'A medicine delivery app for Bangladesh, built end to end from the '
          'mobile app to launch.',
      // TODO(confirm): back end. Only two tags until it is known.
      stack: ['Flutter', 'Dart'],
      links: [LinkItem('Code', 'https://github.com/hasibullah1811/medway')],
    ),
    Project(
      name: 'LanDrop',
      period: 'May 2026',
      description:
          'Zero-configuration file sharing and media streaming on a local '
          'network, with a TV-friendly interface.',
      // TODO(confirm): stack.
      stack: ['Python', 'JavaScript'],
      links: [LinkItem('Code', 'https://github.com/hasibullah1811/landrop')],
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
  education: [
    Credential(
      title: 'Master of Information Technology in Artificial Intelligence',
      detail: 'Macquarie University · Sydney, NSW · 2026',
    ),
    Credential(
      title: 'Bachelor of Science in Computer Science and Engineering',
      detail: 'North South University · Dhaka, Bangladesh · 2023',
    ),
  ],
  research: Research(
    published: [
      Publication(
        title:
            'Deep learning to aid prescription processing & inventory '
            'management for local pharmacies through smartphone application',
        detail:
            'International Journal of Supply Chain Management, Vol. 10, '
            'No. 4, Aug 2021 · Primary author',
        link: LinkItem(
          'Read the paper',
          'https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037',
        ),
      ),
    ],
    // Unpublished course papers: no venue, DOI or peer review. Never call
    // them publications. Slugs are permanent (docs/papers.md). pdfUrl stays
    // null until a redacted public edition is added under web/.
    //
    // TODO(confirm): co-authors have not yet agreed to be named.
    universityProjects: [
      ResearchProject(
        title:
            'Optimizing Bengali Text Generation: A Study on Fine-Tuning '
            'BLOOM-560m with Reduced Parameters for Next Word Prediction',
        source: 'North South University · CSE 498R Directed Research · 2023',
        coAuthors: 'Samira Ali and Irfanuddin Ahmed',
        summary:
            'Teaching a multilingual language model to predict the next word '
            'in Bengali by training only a tiny fraction of it.',
        abstract:
            'Applied LoRA (Low-Rank Adaptation) to the multilingual BLOOM-560m '
            'model for Bengali, with only 0.28% of its parameters trainable. '
            'On a limited Bengali dataset, the adapted model produced more '
            'coherent, context-aware text than the baseline.',
        slug: 'bengali-text-generation-bloom-lora.pdf',
      ),
      ResearchProject(
        title:
            'Enhancing Bengali Language Processing: LoRA-Driven Adaptation in '
            'BLOOM',
        source: 'North South University · Senior Design Project · 2023',
        coAuthors: 'Samira Ali and Irfanuddin Ahmed',
        summary:
            'Cutting the trainable part of a 3-billion-parameter model to 4.9 '
            'million parameters while keeping its Bengali performance.',
        abstract:
            'Combined quantization with LoRA to reduce BLOOM\'s trainable '
            'parameters from 3 billion to 4.9 million (0.16%) with comparable '
            'performance. Covered next-word prediction, question answering '
            'and conversation, using the Bangla2B+ dataset, a proprietary '
            'conversational dataset and more than 300,000 articles. The '
            'adapted model reached lower perplexity than the original.',
        slug: 'bengali-lora-bloom-adaptation.pdf',
        // Do not set pdfUrl until the owner confirms the supervisor's
        // consent: the report's declaration requires it before disclosure.
      ),
      ResearchProject(
        title:
            'Domain Transfer for Low-Resource Machine Translation using RAG: '
            'Solving Retrieval Noise in Clinical English-to-Bengali '
            'Translation',
        source: 'Macquarie University · COMP8851 Major Project · 2026',
        // TODO(confirm): spelling — the cover says "Purayi", the
        // contribution table "Purayil".
        coAuthors: 'Rahba Basheer Vayal Purayil',
        summary:
            'Using retrieval to get medical terms right in English-to-Bengali '
            'translation, and studying the grammar problems it can cause.',
        abstract:
            'Built a RAG pipeline with Pinecone retrieval, semantic '
            'embeddings and a quantized Qwen2.5 model, evaluated with BLEU, '
            'chrF++, BERTScore, glossary matching and a qualitative fluency '
            'review. Retrieval improved medical terminology but disrupted '
            'Bengali grammar, a problem the project calls "context '
            'distraction". Prompt engineering and retrieval optimisation were '
            'tested to reduce it.',
        slug: 'rag-medical-translation-bengali.pdf',
      ),
    ],
    projectTag: 'Unpublished · University project',
    pdfOnRequest: 'PDF available on request',
  ),
  membership: 'Member, Australian Computer Society (ACS)',
);
