# Clipboard Manager Zig multipiattaforma

Questa applicazione, scritta in Zig, permette di gestire la cronologia degli appunti (clipboard history) su Windows, Linux e macOS.

## Funzionalità principali
- Salvataggio automatico degli appunti copiati
- Ricerca e selezione rapida dalla cronologia
- Supporto multipiattaforma (Windows, Linux, macOS)

## Compilazione
- Per Windows:
  zig build-exe main.zig
- Per Linux/macOS:
  zig build-exe main.zig

## Requisiti
- [Zig](https://ziglang.org/download/)

## Build automatica
La build multipiattaforma viene gestita tramite GitHub Actions (vedi file `.github/workflows/zig.yml`).
