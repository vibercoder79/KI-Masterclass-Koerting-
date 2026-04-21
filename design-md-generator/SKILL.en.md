---
name: design-md-generator
description: |
  Extracts the visual design system from a website and/or from design guides (PDF, DOCX, PPTX)
  and generates a DESIGN.md (light + dark mode), interactive HTML previews, and an optional
  branded style guide as PPTX. Reverse-engineering of getdesign.md — free and local, with
  style-guide generation that getdesign.md does not offer.
  Typical use cases: competitive analysis, design-pattern hunting, fast briefing material for
  designers/agencies, machine-readable briefing for Claude Design / Cursor / Lovable / v0
  (your own site or pattern designs).
  (Trigger phrases remain in the skill's working language — German — see SKILL.md.)
version: 1.7.0
---

# DESIGN.md Generator — English Reference

This file mirrors [SKILL.md](SKILL.md) (German, authoritative) for English-speaking readers.
For production use, Claude Code reads SKILL.md — trigger phrases are intentionally in German.

## What this skill produces

- **DESIGN.md** (light mode) — 10-section design system, machine-readable
- **DESIGN-DARK.md** (standalone) — dark mode as a self-contained document
- **preview.html** / **preview-dark.html** — interactive mini-website previews
- **styleguide-[brand].pptx** (optional) — branded style guide as a client deliverable

## Foundation

This skill is a reverse-engineering of the commercial service [getdesign.md](https://getdesign.md/).
It delivers the same output (the 10-section format) but goes further:

- Standalone DESIGN-DARK.md (getdesign.md: light only or appendix)
- Interactive HTML preview as a mini-website
- **Branded style guide as PPTX — not offered by getdesign.md**
- Brand-document integration (brand story, archetypes, tone of voice)
- Argumentative writing style (WHY, not just WHAT)
- Page rhythm as a copy-paste pattern
- Font-substitute recommendations
- Known gaps / transparency section
- Completely free and local — no cloud upload

## Typical use cases

1. **Competitive analysis** — systematically capture a competitor's visual language
2. **Pattern hunting / design inspiration** — extract the blueprint of a reference website
3. **Fast briefing material** — brief a designer / agency / freelancer in under 10 minutes
4. **Claude Design / Claude Code briefing** — machine-readable design briefing for
   agent-based UI builders (Claude Design, Cursor, Lovable, v0) — analyze your own site
   or hand over a reference design as a pattern

## Workflow (summary)

### 0. Ask about sources (always first)

Two questions:

1. Is there a design guide / style guide / brand manual (PDF, DOCX, PPTX) to include?
2. Are there additional brand documents — brand story, archetype descriptions, tone-of-voice
   guidelines? These enrich sections 1 (Visual Theme) and 7 (Do's/Don'ts).

### 1a. Load and analyze the website

Use `defuddle` or `WebFetch` to get the site. Extract CSS custom properties, font-family
declarations, media queries, breakpoints, and (if available) take a visual screenshot.

### 1b. Analyze design documents (if present)

From PDF/DOCX/PPTX style guides extract: colors with official names, typography rules,
layout/spacing, do's/don'ts, accessibility requirements. **Style guide rules take
precedence over CSS analysis** when they conflict — the guide defines intent, the site
shows execution.

### 2. Merge design tokens

Consolidate colors, typography, spacing, shadows, and components from all sources.

### 3. Generate DESIGN.md (light mode)

Produce the 10-section document:

1. Visual theme & atmosphere (argumentative — explain WHY, include page rhythm)
2. Color palette & roles
3. Typography rules (including font-substitute recommendations for proprietary fonts)
4. Component stylings
5. Layout principles
6. Depth & elevation
7. Do's and don'ts
8. Responsive behavior
9. Agent prompt guide
10. Known gaps

### 3b. Generate DESIGN-DARK.md (always additionally)

A fully standalone dark-mode document. If the site has a native dark mode, extract it.
Otherwise derive it using:

- 4-step surface ladder (canvas → surface → card → elevated, never pure black)
- Text-opacity hierarchy (100% / 78% / 50% / 30%)
- Border-opacity hierarchy (12% / 22% / 30%)
- Accent colors remain unchanged

### 4. Generate HTML previews

Two interactive mini-websites with sticky nav, hero, color palette, typography scale,
button variants, card examples, form, spacing scale, border-radius scale, elevation, footer.

### 5. Ask for target directory

Before writing, always ask: current directory / specific folder / desktop.

### 6. Offer the optional PPTX style guide

After the core files are written, offer a 6-8 slide style guide built in the brand's
colors and fonts, dynamically generated from the DESIGN.md. This is the core differentiator
to getdesign.md.

## Quality rules

- Every CSS value must come from the actual website — nothing invented
- Hex colors in lowercase with # (`#171717`)
- Font sizes in px AND rem
- Argumentative writing in section 1 — explain WHY, not just WHAT
- Page rhythm documented as a concrete copy-paste pattern
- Font substitutes always recommended when proprietary fonts are in use
- Known gaps documented honestly — transparency builds trust
- If website and style guide conflict: name both values, the guide takes precedence
- DESIGN-DARK.md must be usable standalone — no "see light version"

## Tips for better results

- Analyze multiple subpages when the homepage lacks UI variety
- For SPAs: defuddle returns the initial HTML — use screenshots for dynamic content
- CSS custom properties are gold — they show the developer's intended design system
- If the site uses a known framework (Tailwind, Material), mention it
- Style guides provide do's/don'ts that cannot be derived from CSS alone — always ask

---

**Note:** The authoritative skill definition with full German trigger phrases lives in
[SKILL.md](SKILL.md). This file is a reference for English-speaking readers.
