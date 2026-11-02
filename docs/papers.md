# Papers

One list for the site and the resume. Use the **Status** wording as it is.

Slugs are **permanent** once approved (2026-11-03). Do not rename them.
Public URLs use `https://www.hasibullah.dev/`. The apex `hasibullah.dev` still
307-redirects there. Switch it to 308 in Vercel → Domains after the merge.

Only redacted "public edition" PDFs go in `web/`. The originals stay in
`assets/paper/`, which is in `.gitignore`. They contain student IDs and email
addresses and must never be committed or deployed.

| Title | Status | Slug | Public URL | PDF |
|---|---|---|---|---|
| Deep learning to aid prescription processing & inventory management for local pharmacies through smartphone application | Published (IJSCM, Vol. 10, No. 4, Aug 2021 · Primary author) | — | https://ojs.excelingtech.co.uk/index.php/IJSCM/article/view/5878/3037 | Hosted by the journal |
| Optimizing Bengali Text Generation: A Study on Fine-Tuning BLOOM-560m with Reduced Parameters for Next Word Prediction | Unpublished university project (North South University, CSE 498R Directed Research, 2023) | `bengali-text-generation-bloom-lora.pdf` | https://www.hasibullah.dev/bengali-text-generation-bloom-lora.pdf | Pending redacted copy |
| Enhancing Bengali Language Processing: LoRA-Driven Adaptation in BLOOM | Unpublished university project (North South University, Senior Design Project, 2023) | `bengali-lora-bloom-adaptation.pdf` | https://www.hasibullah.dev/bengali-lora-bloom-adaptation.pdf | Pending redacted copy **and** supervisor's consent |
| Domain Transfer for Low-Resource Machine Translation using RAG: Solving Retrieval Noise in Clinical English-to-Bengali Translation | Unpublished university project (Macquarie University, COMP8851 Major Project, 2026) | `rag-medical-translation-bengali.pdf` | https://www.hasibullah.dev/rag-medical-translation-bengali.pdf | Pending redacted copy |

The three university projects are not publications: no venue, DOI or peer
review. Never call them journal or conference papers.

## Publishing a redacted PDF

1. Put the redacted file at `web/<slug>` (the exact slug above).
2. Set that project's `pdfUrl` to the slug in `lib/content/portfolio_content.dart`.
   Until then the page shows "PDF available on request".
3. Paper 2 also needs the supervisor's consent before step 2.
4. On the Vercel preview, check that each URL returns `200` with
   `content-type: application/pdf`, not `index.html`:
   `curl -sI https://<preview>/<slug> | grep -iE '^(HTTP|content-type)'`
5. Change the PDF column above to "Live".
