# Portfolio facts — single source of truth

Everything on the site, in `web/index.html` meta tags, the OG image, `web/manifest.json`
and the public CV must agree with this file. Change facts here first, then in the content file.

Items marked `TODO(confirm)` are unresolved. Do not publish them until confirmed.

Last reviewed: 2026-10-03

---

## Identity

| Field | Value |
|---|---|
| Name | Hasibullah Hasib |
| Title (everywhere) | Software Developer |
| Location | Wollongong, NSW |
| Open to | Relocation and remote |
| Status | Open to full-time roles |
| Work rights | Full working rights (Subclass 485) |
| Professional membership | Member, Australian Computer Society (ACS) |

## Contact and links

| Field | Value |
|---|---|
| Email | hi@hasibullah.dev |
| LinkedIn | https://www.linkedin.com/in/md-hasibullah-hasib-39a89a3a5/ |
| GitHub | https://github.com/hasibullah1811 |
| Website (canonical) | https://www.hasibullah.dev/ — apex `hasibullah.dev` currently 307-redirects here |
| CV (public) | Not published yet. Button hidden until a corrected source CV is redacted and approved. Path will be `/cv/Hasibullah_Hasib_CV.pdf` |

Never published: phone number, personal Gmail, the original resume PDF.

---

## Experience

### Elements Bar & Grill — Sydney, NSW
- Role: Full-Stack Developer (site) vs Software Developer (Contract) (resume) — `TODO(confirm)`. Site shows "Software Developer" until confirmed
- Dates: `TODO(confirm)` June vs July 2024 – July 2026. Site shows "2024 – Jul 2026" until confirmed
- Highlights (current site copy):
  - ERP system with a Python backend centralising inventory and logistics across 5 restaurant locations
  - Flutter iPad app routing 500–700 daily orders straight to kitchen printers
  - Flutter mobile app with real-time, location-based clock-in/out for 180 staff

### Binary Craft — Dhaka, Bangladesh (part-time)
- Role: Mobile Developer (site) vs Software Developer (resume) — `TODO(confirm)`. Site shows "Software Developer (part-time)" until confirmed
- Dates: May 2021 – June 2024
- Highlights:
  - Delivered 5 property and invoice management apps with Flutter and React; invoice processing 20% faster for clients
  - Delivered software directly to international clients, leading to the Elements Bar & Grill contract in Australia

### Teaching — New Horizons CLC, Gulshan, Bangladesh
- Year: 2023
- Taught programming fundamentals to about 20 students
- Role title: `TODO(confirm)` (e.g. Instructor / Programming Tutor)

---

## Education

| Degree | School | Location | Year |
|---|---|---|---|
| Master of Information Technology in Artificial Intelligence | Macquarie University | Sydney, NSW | 2026 — completion month `TODO(confirm)` (resume says "Graduating July 2026") |
| Bachelor of Science in Computer Science and Engineering | North South University | Dhaka, Bangladesh | `TODO(confirm)` 2023 vs 2024 |

## Publication

Deep learning to aid prescription processing & inventory management for local pharmacies
through smartphone application. *International Journal of Supply Chain Management (IJSCM)*,
Vol. 10, No. 4, Aug 2021. Primary author.
Link: https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037

---

## Projects (display order)

### 1. StepWise — lead case study
- Status: **In development / private beta. Not publicly released — never claim a launch.**
- URL: https://www.thestepwise.com/ — show or not while in beta: `TODO(confirm)`
- Started: Nov 2025
- Why: built from my own experience of moving to Australia
- What it is: a personal guide to settling in Australia — an AI action plan covering visas and jobs
- Stack: Flutter, PostgreSQL, REST APIs; backend `TODO(confirm)` Flask vs AWS API Gateway vs both. Note: the old `assets/stepwise-diagram` showed **FastAPI + Vertex AI (Gemini 2.5 Flash) + Supabase**, a third answer, so it is not on the site; AI/LLM provider `TODO(confirm)`
- Outcome so far: `TODO(confirm)` (beta users, waitlist, or leave out)
- Assets: `assets/images/stepwise.jpg` (screenshot). The architecture diagram is withheld; see stack

### 2. Minima
- Status: ongoing, open source
- What it is: an interactive machine learning curriculum. Readable MDX lessons with in-browser sandboxes for data, hyperparameters and geometry
- Stack: TypeScript, MDX
- Live: https://www.tryminima.com/
- Code: https://github.com/hasibullah1811/minima
- Assets: `web/img/minima-architecture.png` (linked, not embedded)

### 3. Prism — RAG visualiser
- Date: Jan 2026, open source
- What it is: `TODO(confirm)` which framing. The site currently shows both. The old site said "scatter plots and map views to track vector matches, JSON export of token attribution"; the repo says "visualise, audit and tune text-splitting strategies before calculating embeddings"
- Stack: React, Python, vector database
- Live: https://prism-xi-three.vercel.app/
- Code: https://github.com/hasibullah1811/prism
- Assets: `web/img/prism-architecture.png` (linked, not embedded)

### 4. LandDrop
- Date: May 2026
- Name spelling: `TODO(confirm)` "LandDrop" (resume) vs repo name `landrop`
- What it is: zero-configuration local-network file sharing and media streaming, with real-time sync, HTTP video streaming and a TV-optimised UI
- Stack: `TODO(confirm)`
- Code: https://github.com/hasibullah1811/landrop

### 5. MedWay
- Date: Mar 2021
- What it is: medicine delivery platform for Bangladesh, built end to end. Repo calls it "one of the first" — `TODO(confirm)` keep that claim? Related to the publication?
- Stack: Flutter/Dart (back end `TODO(confirm)`)
- Code: https://github.com/hasibullah1811/medway

### 6. Helping Hand
- Date: July 2020
- What it is: COVID-19 lockdown app connecting people who need help with local volunteers
- Stack: Flutter, Dart, Python, Flask, Firebase
- Outcome: 2,000 active users, 50+ help requests per day. Carried over from the previous live site; reconfirm
- Code: `TODO(confirm)` https://github.com/hasibullah1811/covid-19-helping-hand-find-help-nearby (linked from resume, 48 stars) vs https://github.com/hasibullah1811/Helping-hand-CSE115-Project

---

## Skills (proposed grouping)

Source key: **both** = on site and resume, *site* / *resume* = only one. Strike anything you don't want.

| Group | Items |
|---|---|
| Languages | Java (both), Python (both), TypeScript/JavaScript (both), Dart (both), SQL (both), Kotlin (*site*), C++ (*resume*) |
| Backend & data | REST APIs (both), PostgreSQL (both), MySQL (*site*), Flask (*site*), FastAPI (*resume*), NestJS (*site*), ORM frameworks (*resume*), Firebase (*site*) |
| Frontend & mobile | Flutter (both), React (both) |
| AI & ML | RAG (both), vector databases (*site*), LangChain (*resume*), PyTorch (*resume*), Pandas (*resume*), NumPy (*resume*) |
| Delivery & practices | Git/GitHub (both), CI/CD (both), TDD (*resume*), secure software development (*resume*), Vercel (*site*), Railway (*site*), Linux (*site*) |

Excluded by decision: Azure.
