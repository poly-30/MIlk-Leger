# 🥛 Milk Ledger

A professional **milk delivery billing & management app** built with Flutter. Designed to help milkmen and their customers track daily milk supply, calculate monthly bills, manage customer profiles, and generate printable PDF bills — all stored locally on the device with no internet required.

---

## 📱 Screenshots & Features

| Feature | Description |
|---|---|
| 🧮 **Bill Calculator** | Calculate monthly bills with custom date ranges, rate, supply, and adjustments |
| 👥 **Customer Management** | Add, edit, and delete customer profiles with default rates and supply |
| 📋 **Bill History** | View all past bills, organized by month and customer |
| 📄 **PDF Generation** | Export and share detailed bill PDFs via any app (WhatsApp, Email, etc.) |
| ⚙️ **Settings** | Configure default rate, supply, currency symbol, dark mode |
| 📅 **Custom Date Ranges** | Bill for specific date ranges instead of just a full month |
| 🔧 **Daily Adjustments** | Account for absent days or extra/reduced supply on specific days |

---

## 🏗️ Tech Stack

### Framework
| Technology | Version | Purpose |
|---|---|---|
| **Flutter** | 3.44.4 (stable) | Cross-platform UI framework |
| **Dart** | 3.12.2 | Programming language |

### State Management
| Package | Version | Purpose |
|---|---|---|
| `provider` | ^6.1.2 | App-wide reactive state management using `ChangeNotifier` |

### Database & Storage
| Package | Version | Purpose |
|---|---|---|
| `sqflite` | ^2.3.3 | SQLite database for native (Android/iOS/Windows) |
| `sqflite_common_ffi_web` | ^0.4.3 | SQLite compatibility layer for web (Chrome/Edge) |
| `shared_preferences` | ^2.3.2 | Key-value storage for app settings (dark mode, defaults) |
| `path` | ^1.9.0 | Cross-platform file path resolution |
| `path_provider` | ^2.1.4 | Access to platform-specific storage directories |

### PDF & Sharing
| Package | Version | Purpose |
|---|---|---|
| `pdf` | ^3.11.1 | Programmatic PDF document generation |
| `printing` | ^5.13.2 | Print or share the PDF using platform share sheet |
| `share_plus` | ^10.0.0 | Native share dialog (WhatsApp, Email, Telegram, etc.) |

### Utilities
| Package | Version | Purpose |
|---|---|---|
| `intl` | ^0.19.0 | Date/number formatting (e.g., `DateFormat`, `NumberFormat`) |

### Dev Tools
| Package | Version | Purpose |
|---|---|---|
| `flutter_launcher_icons` | ^0.14.4 | Auto-generate app icons for all platforms from a single PNG |
| `flutter_lints` | ^3.0.0 | Recommended Flutter linting rules |

---

## 🏛️ Architecture

The app follows a **clean layered architecture** using the Provider pattern:

```
lib/
├── main.dart                  # App entry point, Provider setup
├── app.dart                   # MaterialApp, theme configuration
├── core/
│   ├── constants.dart         # App-wide constants (padding, colors)
│   ├── extensions.dart        # Dart extension methods (e.g. toDisplayString)
│   └── theme.dart             # AppTheme (light/dark, color palette)
├── data/
│   ├── database.dart          # SQLite DatabaseHelper singleton (v2 schema)
│   ├── models/
│   │   ├── bill.dart          # Bill model (with custom date range fields)
│   │   ├── customer.dart      # Customer model
│   │   └── settings.dart      # AppSettings model
│   └── repositories/
│       ├── bill_repository.dart      # CRUD for bills table
│       └── customer_repository.dart  # CRUD for customers table
├── providers/
│   ├── calculator_provider.dart   # All billing calculation logic
│   ├── customer_provider.dart     # Customer list state
│   └── settings_provider.dart     # Settings state (theme, defaults)
└── screens/
    ├── main_scaffold.dart         # Bottom nav, tab management
    ├── calculator/
    │   ├── calculator_screen.dart
    │   └── widgets/               # Modular calculator UI cards
    │       ├── customer_selector_card.dart
    │       ├── month_selector_card.dart
    │       ├── price_details_card.dart
    │       ├── supply_details_card.dart
    │       ├── adjustments_card.dart
    │       ├── total_card.dart
    │       ├── breakup_card.dart
    │       └── save_bill_button.dart
    ├── customers/
    │   ├── customers_screen.dart        # Customer list (swipe to delete)
    │   └── add_edit_customer_screen.dart
    ├── history/
    │   ├── history_screen.dart          # Bills list by month
    │   └── bill_detail_screen.dart      # Full bill breakdown + PDF export
    └── settings/
        └── settings_screen.dart
```

### Data Flow
```
UI Widget
   │
   ▼
Provider (ChangeNotifier)
   │  notifyListeners()
   ▼
Repository (CRUD methods)
   │
   ▼
DatabaseHelper (sqflite)
   │
   ▼
SQLite file on device
```

---

## 🗄️ Database Schema

**Database Version:** 2

### `customers` table
| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `name` | TEXT | Customer name |
| `defaultMilkRate` | REAL | Price per litre |
| `defaultDailySupply` | REAL | Default litres/day |
| `defaultDeliveryCharge` | REAL | Fixed daily charge |
| `createdAt` | TEXT | ISO 8601 timestamp |

### `bills` table
| Column | Type | Notes |
|---|---|---|
| `id` | INTEGER PK | Auto-increment |
| `customerName` | TEXT | Snapshot of name at billing time |
| `month` | INTEGER | Month number (1–12) |
| `year` | INTEGER | Billing year |
| `startDate` | TEXT | Custom range start (ISO 8601) |
| `endDate` | TEXT | Custom range end (ISO 8601) |
| `isCustomRange` | INTEGER | 0 = full month, 1 = custom range |
| `milkRate` | REAL | Rate used for this bill |
| `dailySupply` | REAL | Average litres/day |
| `dailyDeliveryCharge` | REAL | Fixed daily charge |
| `absentDays` | INTEGER | Days milkman was absent |
| `adjustedLitres` | REAL | Net extra/reduced supply |
| `totalAmount` | REAL | Final bill amount |
| `createdAt` | TEXT | When the bill was saved |

---

## 🧮 Billing Calculation Logic

```
Total Days  = (endDate - startDate + 1) - absentDays
Total Milk  = (dailySupply × totalDays) + adjustedLitres
Milk Cost   = Total Milk × milkRate
Delivery    = dailyDeliveryCharge × totalDays
Total Bill  = Milk Cost + Delivery
```

---

## 🛠️ Tools Required to Build

### Essential
| Tool | Version | Download |
|---|---|---|
| **Flutter SDK** | 3.44.4+ (stable) | https://flutter.dev/docs/get-started/install |
| **Dart SDK** | 3.12.2+ (included with Flutter) | Bundled with Flutter |
| **Android Studio** | Koala+ (2024.1+) | https://developer.android.com/studio |
| **Android SDK** | API Level 34+ | Via Android Studio SDK Manager |
| **Java / JDK** | 17+ | Bundled with Android Studio |
| **Git** | Any | https://git-scm.com |

### Optional (for specific platforms)
| Tool | Purpose |
|---|---|
| **Xcode** (macOS only) | Build for iOS / macOS |
| **Visual Studio 2022** | Build for Windows desktop |
| **Chrome / Edge** | Run/test web version |

---

## 📋 System Requirements

### Development Machine
| Spec | Minimum | Recommended |
|---|---|---|
| **OS** | Windows 10 / macOS 12 / Ubuntu 20.04 | Windows 11 / macOS 14 |
| **RAM** | 8 GB | 16 GB |
| **Disk Space** | 10 GB free | 20 GB free (for SDK + Gradle cache) |
| **CPU** | Intel i5 / AMD Ryzen 5 | Intel i7 / AMD Ryzen 7 |

> ⚠️ **Important for Windows users**: If your Flutter project is on a **different drive** (e.g., `E:\`) from your user home folder (`C:\`), the Kotlin incremental compiler may crash during Android builds. This is a known Kotlin/Gradle bug. The fix is already applied: `kotlin.incremental=false` is set in `android/gradle.properties`.

### Target Android Device
| Spec | Minimum | Notes |
|---|---|---|
| **Android Version** | Android 6.0 (API 23) | Marshmallow or later |
| **RAM** | 2 GB | App uses very little memory |
| **Storage** | 100 MB free | For the app + SQLite database |
| **Screen** | Any size | Responsive layout with scroll |

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone <your-repo-url>
cd milk-Leger
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run on web (development)
```bash
flutter run -d chrome
```

### 4. Run on Windows desktop
```bash
flutter run -d windows
```

### 5. Build release APK for Android
```bash
flutter build apk
```
The APK will be at:
`build\app\outputs\flutter-apk\app-release.apk`

---

## 📦 Installing on Android

1. Copy `app-release.apk` to your Android phone (via USB, WhatsApp, Email, etc.)
2. Open the file on your phone using the **Files** app
3. Tap **Install**
4. If prompted, enable **"Install from unknown sources"** for your file manager app
5. Open **Milk Ledger** from your app drawer!

---

## 🔧 Configuration

App settings are persisted via `shared_preferences` and managed through the `SettingsProvider`. Users can configure:

- **Currency Symbol** (default: `₹`)
- **Default Milk Rate** (default: 60.0 per litre)
- **Default Daily Supply** (default: 1.0 litre)
- **Default Delivery Charge** (default: 0.0)
- **Dark Mode** toggle

---

## 📄 License

This project is private and intended for personal use.

---

*Built with ❤️ using Flutter*
