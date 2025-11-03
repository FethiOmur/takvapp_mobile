# Takvapp Mobile

Modern Flutter application that helps users track daily prayer times, orient themselves towards the Qibla and explore curated Islamic content. The project is currently under active redesign – the new UI takes inspiration from iOS 17/18 glassmorphism patterns while still remaining fully cross‑platform.

## ✨ Features

- **Onboarding & Email Verification** – guided entry flow that stores device metadata for backend registration.
- **Home Dashboard** – prayer time hero with caching, sunrise/fajr/maghrib cards, story carousel and quick actions.
- **Prayer Times Engine** – Bloc driven workflow that reads the device position, performs geohash based caching and calls backend APIs only when needed.
- **Qibla Finder** – live compass (using `flutter_compass`) with fallback logic when precise location or sensors are unavailable.
- **Qur’an Library (WIP)** – redesigned surah list with quick resume and status indicators.
- **Design System** – consolidated theme tokens (colors, spacing, typography) for consistent styling across screens.

## 🛠 Tech Stack

- Flutter 3.24+
- Dart 3.9
- State management: `flutter_bloc`
- Location services: `geolocator`, `geocoding`, `flutter_compass`
- Persistent cache: `shared_preferences`
- Networking: `dio`
- Code generation: `json_serializable`, `build_runner`

## 📁 Repository Layout

```
├── android/                # Android platform project
├── ios/                    # iOS platform project
├── lib/
│   ├── core/               # Theme, services, models, utilities
│   └── features/           # Screen specific modules (home, qibla, Quran, onboarding…)
├── assets/                 # Images, fonts and other static assets
├── docs/                   # Product documentation, UX references
├── analysis_options.yaml   # Lint rules
├── pubspec.yaml            # Dependencies and Flutter metadata
└── README.md               # You are here
```

> **Note**
> Earlier revisions kept the Flutter project inside a nested `takvapp_mobile/` directory. The repository has now been flattened so `android/`, `ios/`, `lib/`, etc. live at the repository root as expected by standard Flutter tooling.

## 🚀 Getting Started

1. **Install prerequisites**
   - Flutter SDK 3.24 or newer (`flutter doctor` should report no issues).
   - Xcode 15+ for iOS builds / Android Studio with latest SDK tools for Android.

2. **Fetch dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```
   Use `flutter run -d <device_id>` to target a specific simulator/emulator/physical device.

4. **Code generation (if needed)**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## 🧪 Testing & Quality

- Static analysis: `flutter analyze`
- Widget/unit tests: `flutter test` (add suites under `test/` – contributions welcome)
- Follow the lint rules in `analysis_options.yaml` (pedantic + custom guidelines).

## 📦 Environments & APIs

- The application currently uses a fake API service (`FakeApiService`) while the backend is under development. Toggle to the real service by editing `useFakeApi` in `lib/main.dart` once the production endpoints are ready.
- Location permissions are required for prayer times and the Qibla compass. iOS users must enable **Precise Location** for the best experience.

## 🤝 Contributing

1. Fork & clone the repository.
2. Create a branch from `main`: `git checkout -b feat/my-new-feature`.
3. Make your changes, add tests when possible, run `flutter analyze` & `flutter test`.
4. Commit using conventional messages: `feat: …`, `fix: …`, etc.
5. Open a Pull Request against `main` and describe your changes.

## 📄 License

This project is currently private and distributed only to the Takvapp team. Licensing terms will be defined once the project is ready for public release.

## 🙌 Acknowledgements

- Design direction inspired by iOS 17/18 glass components and internal mock-ups provided by the Takvapp product design team.
- Backend API specification prepared by the Takvapp architecture team – integration hooks already exist in the codebase.

---

Need help or have feedback? Open an issue or ping @FethiOmur within the Takvapp workspace.
