# brand-document

A Claude Code plugin that generates professional, on-brand documents using the 11x Agency design language and exports them as pixel-perfect PDFs.

## What it does

The plugin teaches Claude how to create polished client-facing documents (proposals, reports, case studies, one-pagers) that match the 11x Agency visual identity. It uses a fixed A4 page template approach for reliable PDF output with no page-break surprises.

The skill triggers when you ask Claude to create a proposal, report, case study, client deliverable, or any document that should look professional.

## Features

- Fixed A4 page templates (no CSS page-break issues)
- 11x Agency brand design: Cormorant Garamond headings, Outfit body, JetBrains Mono labels
- RGB gradient accents on every page
- Light mode only
- Built-in humanizer pass to remove AI writing patterns
- PDF export via playwright-cli

## Prerequisites

- [playwright-cli](https://www.npmjs.com/package/playwright-cli) for PDF generation
- A local HTTP server (uses `npx serve` by default)

## Install

```
/plugin marketplace add 11x-agency/claude-marketplace
/plugin install brand-document@11x-marketplace
```

## Usage

Just ask Claude to create a document:

```
Create a proposal for [client] about [project]
Make a case study PDF for [project]
Turn this into a professional report
```

Claude will generate the HTML with fixed page templates and export it as a PDF.

## Links

- [11x Agency](https://11x.agency)
