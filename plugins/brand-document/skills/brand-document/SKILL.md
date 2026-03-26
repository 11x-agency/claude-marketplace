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
| `background` | `#FAFAFA` | Page background |
| `surface` | `#FFFFFF` | Cards on hover, elevated elements |
| `surface-alt` | `#F4F4F5` | Secondary panels |
| `foreground` | `#0A0A0A` | Headings, primary text |
| `text-secondary` | `#545454` | Body copy, descriptions |
| `text-muted` | `#888888` | Labels, mono decorators, page numbers |
| `border` | `#DBDBDB` | Visible borders, pills |
| `border-subtle` | `#E8E8E8` | Card grid lines, question dividers |

### The RGB gradient (signature element)

```css
linear-gradient(90deg,
  #33090F 0%, #C93B32 13%, #F8863A 25%, #C8D47A 38%,
  #6A8E50 50%, #002211 62%, #001A3D 74%, #3B7FCC 86%, #99CCFF 97%
)
```

Where the gradient appears:
- 4px bar at the top of every page
- Section divider lines between major sections within a page
- Flow step number border colors pick from the gradient (red, orange, green, blue)
- Status indicator dots

Where the gradient does NOT appear:
- As section backgrounds
- On body text
- On icons

### Typography

| Family | CSS Variable | Role |
|--------|-------------|------|
| Cormorant Garamond | `--font-serif` | Headlines (h1, h2, h3). Weight 300. |
| Outfit | `--font-sans` | Body copy, descriptions. Weight 300-400. |
| JetBrains Mono | `--font-mono` | Section prefixes, labels, page numbers, pills. Weight 400. |

Load from Google Fonts:
```html
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400&family=Outfit:wght@300;400;500&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

### Type scale

| Element | Font | Size | Weight | Extras |
|---------|------|------|--------|--------|
| h1 | Serif | 3.2rem | 300 | `line-height: 0.95; letter-spacing: -0.04em` |
| h2 | Serif | 2rem | 300 | `letter-spacing: -0.04em` |
| h3 | Serif | 1.35rem | 300 | `letter-spacing: -0.03em` |
| Body | Sans | 14px | 300 | `line-height: 1.75` |
| Labels / prefixes | Mono | 10-11px | 400 | `letter-spacing: 0.15em` |
| Page numbers | Mono | 10px | 400 | |

### Section prefixes

Every section starts with a mono prefix above the heading:
```
// 01 SECTION NAME
```
Format: `//` + space + two-digit number + space + uppercase label. Color: `text-muted`.

### Logo

```html
<span class="bracket">[</span> 11x Agency <span class="bracket">]</span>
```
Font: mono, 12px in header, 10px in footers. Brackets use `text-muted` color.

## HTML template

A starter template is bundled at `assets/template.html` (relative to this skill). Read it before generating any document — it contains the full CSS, page structure, and component markup. Use it as your starting point and adapt it to the content you're building.

## Page template architecture

This is the most important part of the skill. Every document is built from fixed-size A4 page divs. Content does not auto-flow between pages. You decide what goes on each page.

### Why this approach

CSS page breaks are unreliable. They split headings from content, cut card grids in half, and leave huge whitespace gaps. Fixed page templates give pixel-perfect control over every page. Each page looks intentionally designed, like a slide deck.

### Page structure

```html
<div class="page">
  <div class="page-gradient"></div>  <!-- 4px RGB bar at top -->
  <div class="page-content">
    <!-- Your content here -->
    <div class="spacer"></div>       <!-- Pushes footer down -->
  </div>
  <div class="page-footer">
    <div class="page-footer-logo">[11x Agency]</div>
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
  background: var(--background);
  position: relative;
  overflow: hidden;
  page-break-after: always;
  display: flex;
  flex-direction: column;
}

.page:last-child { page-break-after: auto; }

.page-gradient {
  height: 4px;
  background: var(--gradient-rgb);
  flex-shrink: 0;
}

.page-content {
  flex: 1;
  padding: 48px 56px;
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
2. Estimate how much fits on one A4 page (the content area is roughly 210mm x 250mm after padding, gradient bar, and footer)
3. Group related sections that fit together. Two short sections on one page is better than one section per page with lots of whitespace.
4. If a section is too tall for a page, split it across two pages at a natural break point (e.g., after a paragraph, between card grids)
5. The first page usually has: logo, title, lead text, meta info, divider, then the first section
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

**Status grid** (3 columns with colored dots):
```html
<div class="status-grid">
  <div class="status-card">
    <div class="status-dot" style="background: #F8863A;"></div>
    <h3>Status name</h3>
    <p>Description</p>
  </div>
</div>
```

**Flow steps** (numbered vertical flow):
```html
<div class="flow">
  <div class="flow-step">
    <div class="flow-number" style="border-color: #C93B32;">1</div>
    <div class="flow-content">
      <h3>Step title</h3>
      <p>Step description</p>
    </div>
  </div>
</div>
```
Use gradient colors for step borders: 1=#C93B32, 2=#F8863A, 3=#6A8E50, 4=#3B7FCC.

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

**Divider** (gradient line between sections on the same page):
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
- `printBackground: true` renders the gradient and background colors
- `displayHeaderFooter: false` prevents Chrome from adding date/URL/page annotations
- All margins `'0'` because the page template handles its own padding

## Do / Don't

**Do:**
- Use fixed A4 page divs for every document
- Put the RGB gradient bar at the top of every page
- Include page numbers and logo in every page footer
- Use serif for headings, sans for body, mono for labels
- Keep text light weight (300) for the editorial feel
- Run a humanizer pass on all copy
- Group multiple short sections on one page to avoid waste

**Don't:**
- Use dark mode
- Rely on CSS page-break rules (they're unreliable)
- Let content overflow a page div
- Use bold/heavy font weights (no 700+)
- Add emojis
- Use the gradient as a background fill on large areas
- Hardcode hex values in elements (use CSS variables)
