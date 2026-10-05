# Portfolio facts — single source of truth

Everything on the site, in `web/index.html` meta tags, the OG image, `web/manifest.json`
and the public CV must agree with this file. Change facts here first, then in the content file.

Items marked `TODO(confirm)` are unresolved. Do not publish them until confirmed.

Last reviewed: 2026-10-05 (round 3: location, LeetCode, About copy)

---

## Identity

| Field | Value |
|---|---|
| Name | Hasibullah Hasib |
| Title (everywhere) | Software Developer |
| Location (on the page) | NSW, Australia |
| Location (meta description only) | Wollongong, NSW |
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
| LeetCode | https://leetcode.com/u/hasibullah/ |
| Website (canonical) | https://www.hasibullah.dev/ — apex `hasibullah.dev` currently 307-redirects here |
| CV (public) | Not published yet. Button hidden until a corrected source CV is redacted and approved. Path will be `/cv/Hasibullah_Hasib_CV.pdf` |

Never published: phone number, personal Gmail, the original resume PDF.

## Hero and About

- Hero tagline: "Software developer building practical apps in Flutter, Python and FastAPI."
- About (owner's wording, keep as is): "I'm a software developer who builds things people actually use. In Dhaka I made a COVID-19 help app that reached 2,000 users. In Australia I built an ERP system and staff apps that run across five restaurants, and now I'm building StepWise, an app for people settling into a new country, because I've made that move myself. I work mostly with Flutter, Python and FastAPI, and I hold a Master's in IT (AI) from Macquarie. I'm open to full-time roles, with full working rights in Australia."
- About numbers: 5 restaurant locations · 500–700 daily orders · 180 staff · 2,000 users
- Journey heading: "From Bangladesh to Australia"
- No "core stack" summary. Stack is shown as tags on project cards and journey entries

---

## Experience

### Elements Bar & Grill — Sydney, NSW
- Role: Full-Stack Developer (site) vs Software Developer (Contract) (resume) — `TODO(confirm)`. Site shows "Software Developer" until confirmed
- Dates: 2024 – 2026 (no start or end month shown, by decision)
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
| Bachelor of Science in Computer Science and Engineering | North South University | Dhaka, Bangladesh | 2023 |

## Publication

Deep learning to aid prescription processing & inventory management for local pharmacies
through smartphone application. *International Journal of Supply Chain Management (IJSCM)*,
Vol. 10, No. 4, Aug 2021. Primary author.
Link: https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037

---

## Projects (display order)

### 1. StepWise — lead case study
- Status: **In development / private beta. Not publicly released — never claim a launch.**
- URL: https://www.thestepwise.com/ — **not linked** while in development / private beta (decision)
- Started: Nov 2025
- Why: built from my own experience of moving to Australia
- What it is: a personal guide to settling in Australia — an AI action plan covering visas and jobs
- Stack: Flutter front end; FastAPI + PostgreSQL backend; AI via Gemini on Google Cloud Vertex AI. (Not Flask, not AWS API Gateway. The resume still says API Gateway; fix it in the next CV update)
- Outcome so far: in private beta, no public metrics
- Assets: `assets/images/stepwise.jpg` (screenshot). The architecture diagram is withheld; see stack

### 2. Minima
- Status: ongoing, open source
- What it is: an interactive machine learning curriculum. Readable MDX lessons with in-browser sandboxes for data, hyperparameters and geometry
- Stack: TypeScript, MDX
- Live: https://www.tryminima.com/
- Code: https://github.com/hasibullah1811/minima
- Assets: `web/img/minima-architecture.png` (shown inline, loaded on scroll, and linked full size)

### 3. Prism — RAG visualiser
- Date: Jan 2026, open source
- What it is: `TODO(confirm)` which framing. The site currently shows both. The old site said "scatter plots and map views to track vector matches, JSON export of token attribution"; the repo says "visualise, audit and tune text-splitting strategies before calculating embeddings"
- Stack: React, Python, vector database
- Live: https://prism-xi-three.vercel.app/
- Code: https://github.com/hasibullah1811/prism
- Assets: `web/img/prism-architecture.png` (shown inline, loaded on scroll, and linked full size)

### 4. LanDrop
- Date: May 2026
- Name spelling: "LanDrop" (repo: `landrop`). The resume says "LandDrop"; fix it in the next CV update
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
