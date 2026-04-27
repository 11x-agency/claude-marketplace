---
name: brand-document
description: Generate on-brand HTML documents styled with the 11x Agency design language and export them as pixel-perfect PDFs. Use this skill whenever the user asks to create a proposal, report, case study, one-pager, client deliverable, or any document that should look professional and match the 11x Agency visual identity. Also trigger when the user mentions "create a PDF", "make a doc for the client", "brand document", or wants to turn content into a polished deliverable.
---

# Brand document generator

Create professional documents using the 11x Agency design language. The output is a standalone HTML file with fixed A4 page templates that exports to a clean PDF via playwright-cli.

## Design system

Always use light mode. No dark mode.

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `cream` | `#f9f7f2` | Page background |
| `ash-950` | `#21211e` | Headings, primary text, logo |
| `ash-700` | `#4a4a45` | Body copy |
| `ash-500` | `#7a7a73` | Meta labels, page numbers |
| `clay-600` | `#c14606` | Primary accent — rules, dividers, kicker, mono prefixes, borders on numbered/status elements |
| `clay-500` | `#d96409` | Secondary accent (use sparingly for hover/highlight states) |
| `border` | `#e2dcd0` | Visible borders |
| `border-subtle` | `#ece6da` | Card grid lines, question dividers |

### Clay accent (signature element)

The 11x mark of identity is **3px solid clay-600** rules. Where it appears:

- Top of every page: a double-rule (3px clay-600 line + 3px clay-600 line, 8px apart) — see `.page-rule` in the template
- Section dividers between major sections within a page (`<hr class="divider">`)
- Underline beneath the logo (96px wide)
- Bottom border on the cover kicker
- Borders on flow-step numbers, status dots, and pills
- Color of mono section prefixes (`// 01 SECTION`)

The clay accent does NOT appear:
- As a section background fill
- On body text
- On icons or imagery

There is no rainbow gradient. The previous gradient system has been retired.

### Typography

| Family | CSS Variable | Role |
|--------|-------------|------|
| Grenze Gotisch | `--font-display` | Cover kicker only. Weight 500. |
| Lora | `--font-serif` | Headlines (h1, h2, h3) and body copy. Weight 400-500. |
| JetBrains Mono | `--font-mono` | Section prefixes, meta labels, page numbers, pill text. Weight 400. |

Load from Google Fonts:
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Grenze+Gotisch:wght@400;500;600&family=Lora:ital,wght@0,400..600;1,400..600&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

### Type scale

| Element | Font | Size | Weight | Extras |
|---------|------|------|--------|--------|
| `.kicker` (cover) | Grenze Gotisch | 4.4rem | 500 | `color: clay-600; border-bottom: 4px solid clay-600` |
| h1 | Lora | 3.4rem | 500 | `line-height: 1.05; letter-spacing: -0.02em` |
| h2 | Lora | 2rem | 500 | `letter-spacing: -0.02em` |
| h3 | Lora | 1.3rem | 500 | `letter-spacing: -0.01em` |
| Body | Lora | 14px | 400 | `line-height: 1.7; color: ash-700` |
| Lead | Lora | 16px | 400 | `color: ash-700` |
| Labels / prefixes | Mono | 10-11px | 400 | `letter-spacing: 0.15em; uppercase` |
| Page numbers | Mono | 10px | 400 | `color: ash-500` |

Lora reads thin below weight 400 in print — never use 300.

### Section prefixes

Every section starts with a mono prefix above the heading:
```
// 01 SECTION NAME
```
Format: `//` + space + two-digit number + space + uppercase label. Color: `clay-600`.

### Eyebrow / top rule

Every page opens with the same eyebrow band (matches the LinkedIn carousel exactly): logo on the left, a clay-600 rule from the logo's right edge to the right margin, and a second clay-600 rule edge-to-edge directly below it.

```html
<div class="top-rule">
  <img class="top-rule__logotype" src="logotype-11x.svg" alt="11x" />
  <span class="top-rule__line"></span>
  <span class="top-rule__line-bottom"></span>
</div>
```
- Logo: `height: 22px`, anchored bottom-left of the band
- Top line: starts at `left: 96px` (just past the logo), runs to `right: 56px`, 2px clay-600
- Bottom line: full-width edge-to-edge, 6px below the top line, 2px clay-600
- Band height: 64px, padding `32px 56px 0`

The social slides scale this same eyebrow up (logo 52px, 3px rules) for square 1080×1350 carousels. PDF deliverables use the smaller version so the eyebrow stays a refined header rather than a hero block.

The footer logo (smaller, 18px) appears alongside the page number and uses the same SVG. The bracketed mono `[ 11x Agency ]` pattern from the previous brand has been retired.

## HTML template

A starter template is bundled at `assets/template.html` (relative to this skill). Read it before generating any document — it contains the full CSS, page structure, and component markup. Use it as your starting point and adapt it to the content you're building.

Bundled assets in `assets/`:
- `template.html` — A4 starter
- `logotype-11x.svg` — primary logo (used in header + footer)

## Page template architecture

This is the most important part of the skill. Every document is built from fixed-size A4 page divs. Content does not auto-flow between pages. You decide what goes on each page.

### Why this approach

CSS page breaks are unreliable. They split headings from content, cut card grids in half, and leave huge whitespace gaps. Fixed page templates give pixel-perfect control over every page. Each page looks intentionally designed, like a slide deck.

### Page structure

```html
<div class="page">
  <div class="top-rule">                 <!-- eyebrow: logo + double clay rule -->
    <img class="top-rule__logotype" src="logotype-11x.svg" alt="11x" />
    <span class="top-rule__line"></span>
    <span class="top-rule__line-bottom"></span>
  </div>
  <div class="page-content">
    <!-- Your content here -->
    <div class="spacer"></div>           <!-- Pushes footer down -->
  </div>
  <div class="page-footer">
    <div class="page-footer-logo"><img src="logotype-11x.svg" alt="11x" /></div>
    <div class="page-footer-num">1 / 5</div>
  </div>
</div>
```

### Critical CSS for pages

```css
@page { size: A4; margin: 0; }

.page {
  width: 210mm;
  height: 297mm;
  background: var(--cream);
  position: relative;
  overflow: hidden;
  page-break-after: always;
  display: flex;
  flex-direction: column;
}

.page:last-child { page-break-after: auto; }

.top-rule {
  position: relative;
  padding: 32px 56px 0;
  flex-shrink: 0;
  z-index: 2;
  height: 64px;
}
.top-rule__logotype {
  height: 22px;
  position: absolute;
  left: 56px;
  bottom: 14px;
}
.top-rule__line {
  position: absolute;
  left: 96px;
  right: 56px;
  bottom: 14px;
  height: 2px;
  background: var(--clay-600);
}
.top-rule__line-bottom {
  position: absolute;
  left: 56px;
  right: 56px;
  bottom: 8px;
  height: 2px;
  background: var(--clay-600);
}

.page-content {
  flex: 1;
  padding: 40px 56px 24px;
  display: flex;
  flex-direction: column;
}

.page-footer {
  padding: 0 56px 32px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}

.spacer { flex: 1; }
```

### How to lay out content across pages

1. Start by writing all the content sections
2. Estimate how much fits on one A4 page (the content area is roughly 210mm × 250mm after padding, top rule, and footer)
3. Group related sections that fit together. Two short sections on one page is better than one section per page with lots of whitespace.
4. If a section is too tall for a page, split it across two pages at a natural break point (e.g., after a paragraph, between card grids)
5. The first page is the cover: kicker, h1, lead, meta, divider, then the first section
6. The last page usually has the least content and can include a sign-off or footer section

### Component patterns

**Card grid** (2 columns):
```html
<div class="card-grid">
  <div class="card">
    <div class="card-label">Label</div>
    <h3>Title</h3>
    <p>Description</p>
  </div>
  <!-- more cards -->
</div>
```

**Status grid** (3 columns with clay dots):
```html
<div class="status-grid">
  <div class="status-card">
    <div class="status-dot"></div>
    <h3>Status name</h3>
    <p>Description</p>
  </div>
</div>
```
All dots are clay-600 — no inline color overrides.

**Flow steps** (numbered vertical flow):
```html
<div class="flow">
  <div class="flow-step">
    <div class="flow-number">1</div>
    <div class="flow-content">
      <h3>Step title</h3>
      <p>Step description</p>
    </div>
  </div>
</div>
```
All step numbers use clay-600 borders — no inline color overrides.

**Questions list** (numbered with mono prefixes):
```html
<ul class="questions">
  <li><span><strong>Label</strong> — Description text</span></li>
</ul>
```

**Tech pills**:
```html
<div class="pills">
  <span class="pill">Technology</span>
</div>
```

**Divider** (3px clay-600 line between sections on the same page):
```html
<hr class="divider">
```

**Meta info** (key-value pairs, used on cover pages):
```html
<div class="meta">
  <div class="meta-item">
    <span class="meta-label">Client</span>
    <span class="meta-value">Company Name</span>
  </div>
</div>
```

## Writing style

After generating the document content, run a humanizer pass on all text. Remove these AI writing patterns:

- Promotional language: "groundbreaking", "seamless", "game-changing"
- Significance inflation: "pivotal", "crucial", "vital role"
- Negative parallelisms: "It's not just X, it's Y"
- Rule of three: forced groups of three adjectives or concepts
- Em dash overuse
- Sloganish one-liners
- Generic positive conclusions: "the future looks bright"
- Copula avoidance: "serves as" instead of just "is"

Write like you're explaining something to a smart colleague. Short sentences, plain language, specific over vague. Vary the rhythm. It's fine to start sentences with "And" or "So" or "But". If something is simple, say it simply.

## PDF generation

After creating the HTML file, generate the PDF using playwright-cli:

```bash
# Start a local server to serve the HTML
npx -y serve <directory> -p 3456 &
sleep 2

# Open in playwright and generate PDF
playwright-cli open http://localhost:3456/<filename>.html
playwright-cli run-code "async page => await page.pdf({ path: '<output-path>.pdf', width: '210mm', height: '297mm', printBackground: true, displayHeaderFooter: false, margin: { top: '0', right: '0', bottom: '0', left: '0' } })"

# Clean up
playwright-cli close
kill %1 2>/dev/null
```

The key settings:
- `width: '210mm', height: '297mm'` matches the page div dimensions exactly
- `printBackground: true` renders the cream background and clay rules
- `displayHeaderFooter: false` prevents Chrome from adding date/URL/page annotations
- All margins `'0'` because the page template handles its own padding

The HTML file must be served from the same directory as `logotype-11x.svg` so the relative `src` paths resolve.

## Do / Don't

**Do:**
- Use fixed A4 page divs for every document
- Put the double clay-600 rule at the top of every page
- Include page numbers and SVG logo in every page footer
- Use Lora at weight 400-500 for headings and body, JetBrains Mono for labels, Grenze Gotisch only for the cover kicker
- Run a humanizer pass on all copy
- Group multiple short sections on one page to avoid waste

**Don't:**
- Use dark mode
- Rely on CSS page-break rules (they're unreliable)
- Let content overflow a page div
- Use Lora at weight 300 — reads too thin in print
- Add emojis
- Reintroduce the old multi-color gradient
- Use the textured social background — PDFs use solid cream for legibility
- Hardcode hex values in elements (use CSS variables)
