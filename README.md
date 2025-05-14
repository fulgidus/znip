# znip

Questo repository contiene:

- **zig-app/**: Clipboard manager multipiattaforma scritto in Zig (Windows, Linux, macOS)
- **site/**: Sito web Next.js 15+ per la documentazione e la presentazione del progetto, pronto per il deploy su GitHub Pages

## Versioning e CI/CD

- Le pipeline di build e deploy vengono attivate solo al push di un tag che inizia con:
  - `zig-app-v` per la build multipiattaforma Zig
  - `site-v` per il deploy del sito web

Consulta le cartelle `.github/workflows/` per i dettagli sulle pipeline.
