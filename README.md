# Exchange Rate Tracker

A lightweight SwiftUI app that tracks real‑time FX and crypto prices and lets users curate a personal watch‑list. Updates every 1 seconds—no backend required.

---

## ✨ Features

- **Live rates** for selected assets with automatic refresh every 1 s.
- **Pull‑to‑refresh** and colour‑coded day change.
- **Searchable add screen** grouped as *Popular*, *Crypto*, and *Other*.
- **Persistent selection** via local storage.
- Graceful **error handling** and offline fallback.
- Dark & light mode support.

---

## 🏛 Architecture

```
Domain        Asset · ExchangeRate · Protocols
Data
 ├─ Networking   APIService  (OpenExchangeRates)
 └─ Persistence  StorageService (UserDefaults)
Presentation
 ├─ ViewModels   Home · AddAsset
 └─ Views        SwiftUI screens & cells
Tests           Mocks + XCTest suites
```

*MVVM* with one‑way data flow, `@MainActor` safety, Combine publishers.

---

## 🛠 Tech Stack

| Layer | Frameworks |
|-------|------------|
| UI | SwiftUI (iOS 17) |
| Reactive | Combine |
| Network | URLSession + async publishers |
| Storage | UserDefaults (easily swappable for SwiftData) |
| Tooling | Swift 5.9 · Xcode 16 · SPM |

---

## 🔧 Setup

1. **Clone**
   ```bash
   git clone https://github.com/<your‑fork>/ExchangeRateTracker.git
   open ExchangeRateTracker.xcodeproj
   ```
2. **API key** — create a free account at **openexchangerates.org** and copy your *App ID*.
3. **Configure** – open `Sources/Data/Networking/APIService.swift` and replace the placeholder:
   ```swift
   private enum Constants { static let appId = "<YOUR_APP_ID>" }
   ```
4. **Run** on an iOS 17+ simulator or device.

---

## ✅ Unit Tests

Run with **⌘U**.

| Suite | Coverage |
|-------|----------|
| `HomeViewModelTests` | reload · remove · format |
| `AddAssetViewModelTests` | initial · load · search · toggle · error |

Mocks isolate network and storage; tests are `@MainActor` safe.

---

## 📄 License

MIT — see `LICENSE`.

