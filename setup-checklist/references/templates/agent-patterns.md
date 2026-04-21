---
paths:
  - "**"
---

# Agent-Patterns

Verwende diese Patterns als Orientierung fuer die Team-Zusammenstellung:

## Neue Feature-Story
Lead (Sonnet) + Explore (Haiku) + Plan (Sonnet)
// Lead koordiniert, Explore recherchiert Codebase, Plan erstellt Implementierungsplan

## Architektur-Review
Lead (Opus) + 2 Debatter-Agents (Sonnet)
// Zwei Agents argumentieren fuer/gegen einen Ansatz, Lead entscheidet

## Bugfix mit unklarer Ursache
Lead (Sonnet) + 2 Hypothesen-Agents (Racing)
// Zwei Agents verfolgen parallel verschiedene Hypothesen, schnellster gewinnt

## Grosse Refactoring-Story
Lead (Sonnet) + Builder + Tester parallel
// Builder implementiert, Tester prueft laufend — Fehler werden sofort gefunden
