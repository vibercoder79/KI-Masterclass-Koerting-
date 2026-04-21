---
paths:
  - "src/api/**/*.ts"
  - "src/middleware/**/*.ts"
---

# API Security

// Jeder Endpoint braucht Authentication-Middleware — keine ungeschuetzten Routen
// Input-Validierung mit zod oder aehnlichem Schema vor der Verarbeitung
// Rate-Limiting fuer alle oeffentlichen Endpoints (express-rate-limit o.ae.)
// Keine Secrets oder API-Keys in Response-Objekten zurueckgeben
// CORS restriktiv konfigurieren — nur bekannte Origins erlauben
// SQL/NoSQL-Injection verhindern: Prepared Statements, kein String-Concat
// Sensible Daten (Passwoerter, Tokens) niemals loggen
// HTTP-Security-Header setzen (Helmet.js o.ae.): X-Content-Type-Options, Strict-Transport-Security
// Fehlerresponses ohne interne Details — keine Stack-Traces an Clients
