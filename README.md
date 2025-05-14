# znip

This repository contains:

- **zig-app/**: Cross-platform clipboard manager written in Zig (Windows, Linux, macOS)
- **site/**: Next.js 15+ website for documentation and project showcase, ready for deployment on GitHub Pages

## Versioning and CI/CD

- Build and deploy pipelines are triggered only when pushing a tag that starts with:
  - `zig-app-v` for the Zig cross-platform build
  - `site-v` for the website deployment

See the `.github/workflows/` folder for pipeline details.
