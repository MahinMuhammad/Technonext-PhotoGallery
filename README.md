# Technonext-PhotoGallery

This an app that presents photos in a Gallary like approach. (Development on going)

### Environments & Build Configurations

This project includes three build configurations and matching schemes to model real-world environments:

- Debug-Dev → Scheme: PicBook-Dev <br>
Purpose: local development & debugging <br>
Display name: PicBook (Dev) <br>
Bundle ID suffix: .dev <br>

- Debug-Staging → Scheme: PicBook-Staging <br>
Purpose: pre-production mirror for QA <br>
Display name: PicBook (Staging) <br>
Bundle ID suffix: .Staging <br>

- Release-Prod → Scheme: PicBook-Prod <br>
Purpose: production builds/archives <br>
Display name: PicBook <br>

All environments currently point to the same Picsum endpoint (https://picsum.photos). The separation exists to enable easy switching to distinct backends later (no code changes).
Differences across environments are expressed via build settings and xcconfig files (e.g., display name, bundle ID, logging verbosity, and cache TTL).
