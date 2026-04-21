# Projekt: {{PROJEKTNAME}}

## Build & Test
# TODO: Anpassen an dein Projekt
npm run dev       # Entwicklungsserver starten
npm test          # Tests ausfuehren
npm run build     # Production Build

## Architektur
// TODO: Beschreibe die Architektur deines Projekts
// Einstiegspunkt: src/index.ts
// Keine direkten DB-Queries ausserhalb von src/db/

## Regeln
// Vor jeder Code-Aenderung: betroffene Dateien vollstaendig lesen
// Secrets niemals im Code — nur via .env oder Secret Manager
// Bash-Outputs bei Bedarf mit | head -100 begrenzen
// Bei fehlschlagenden Tests: Root Cause fixen, nicht den Test anpassen
