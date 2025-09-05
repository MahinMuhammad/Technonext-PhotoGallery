# Technonext-PhotoGallery (PicBook)

This is an iOS photo gallery app built with SwiftUI.  
It presents photos in a grid, allows opening them in full-screen with zooming, and supports saving and sharing.

## Features Implemented

- Photo grid view using data from [Picsum API](https://picsum.photos/).
- Full-screen photo viewer with pinch-to-zoom.
- Networking with URLSession.
- Combine framework used for handling async network calls (Specifically in Image loading).
- Image caching for better performance and for no internet usage.
- API response caching to reduce repeated network calls and for no internet usage.
- Save photo to device in JPEG format.
- Share photo using iOS native share sheet.
- Multiple build configurations (Dev, Staging, Prod) with separate schemes, bundle IDs, and display names.

## Environments & Build Configurations

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
