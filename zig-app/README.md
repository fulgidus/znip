# Cross-platform Clipboard Manager in Zig

This application, written in Zig, allows you to manage clipboard history on Windows, Linux, and macOS.

## Main Features
- Automatic saving of copied clipboard entries
- Fast search and selection from history
- Cross-platform support (Windows, Linux, macOS)

## Build
- For Windows:
  zig build-exe main.zig
- For Linux/macOS:
  zig build-exe main.zig

## Requirements
- [Zig](https://ziglang.org/download/)

## Automated Build
Cross-platform builds are managed via GitHub Actions (see `.github/workflows/zig.yml`).
