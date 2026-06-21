# Notes Manager — Authentication & Notes App (Firebase)

A Flutter app where users sign up, log in, and manage personal notes stored in Cloud Firestore, scoped strictly to the logged-in user with real-time sync.

Built for the Ipopiads Flutter Developer Assessment.

---

## 1. Project Overview

Two modules:

- **Authentication** — email/password signup and login via Firebase Authentication, with full client-side validation and Firebase error handling.
- **Notes** — create, edit, delete, and star personal notes in Cloud Firestore, with live updates (no manual refresh needed) and a dashboard that shows a welcome message, total note count, and an "All Notes / Starred" tab switcher.

The app is built with Clean Architecture (domain / data / presentation per feature) and is responsive across phone, tablet, and desktop window sizes.

---

## 2. Architecture & State Management

The `domain` layer never imports Firebase packages — it only knows about abstract repository contracts. `data` is the only layer that talks to `firebase_auth` / `cloud_firestore` directly. `presentation` never calls Firebase directly either; it only calls usecases.

**State management — deliberately split, not arbitrary:**

- **Auth → `flutter_bloc`**. Auth is a small set of discrete events (signup, login, logout) with clear terminal states (loading, authenticated, unauthenticated, failure) — exactly what BLoC's event/state model is built for.
- **Notes → `GetX`**. Notes is a continuously-changing list driven by a live Firestore stream. GetX's reactive `.obs` variables plus a `StreamSubscription` inside a `GetxController` map onto that more directly, with less boilerplate than a BLoC would need for the same continuous-stream pattern.
- **GetX is also used for navigation** (`GetMaterialApp`, `Get.to` / `Get.off` / `Get.offAll`) so the app isn't running two separate routing systems.

**Dependency injection** — a single `get_it` container (`core/di/injector.dart`) wires datasources → repositories → usecases → bloc/controller. Both the BLoC and the GetX controller pull their dependencies from the same container; there's one source of truth for how objects are constructed.

**Why navigation is widget-based, not named-route-based:** GetX's named-route resolution (`Get.toNamed` / `Get.offAllNamed`) had a reproducible crash in testing on this project's `get` version. Rather than chase that, navigation between auth ↔ dashboard ↔ add/edit-note is done via direct widget references (`Get.to(() => const Screen())`), which sidesteps the issue entirely and is arguably simpler to reason about for an app this size. `getPages`/`AppRoutes` still exist for the splash screen only.

---

## 3. Tech Stack

| Package | Why |
|---|---|
| `firebase_core`, `firebase_auth`, `cloud_firestore` | Auth + database, used directly via their native SDKs (not REST/Dio) so Firestore's live listeners work for real-time updates |
| `flutter_bloc`, `equatable` | Auth state management |
| `get` | Notes state management + app navigation |
| `get_it` | Dependency injection |
| `intl` | Date formatting on note cards |
| `flutter_lints` | Static analysis |
| `bloc_test`, `mocktail` (dev) | Available for unit-testing the `AuthBloc` if you choose to add tests |

---

## 4. Prerequisites

- Flutter 3.19+ (project pinned via `fvm` to 3.24.5 during development — `flutter --version` to check yours)
- Android Studio (Android SDK 35, since `firebase_auth` pulls in a library requiring it) or Xcode for iOS
- A Google account to create a Firebase project
- Node.js (needed for the Firebase CLI) — `node -v` to check

---

## 5. Setup & Installation

### 5.1 Clone and install Flutter dependencies

```bash
git clone <your-repo-url>
cd ipopi_notes_vault
flutter pub get
```

### 5.2 Create a Firebase project

1. Go to [console.firebase.google.com](https://console.firebase.google.com) → **Add project**.
2. Name it anything (e.g. `notes-manager-app`) — Google Analytics is optional, skip it.

### 5.3 Install the Firebase CLI and FlutterFire CLI

The FlutterFire CLI shells out to the official Firebase CLI, so both are required:

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

### 5.4 Connect the Flutter project to your Firebase project

From the project root:

```bash
flutterfire configure
```

Select your Firebase project, then select platforms **android**, **ios**, and **web** (these are the platforms officially supported by `firebase_auth`/`cloud_firestore` — Windows/Linux desktop are not). This generates `lib/firebase_options.dart` and drops `google-services.json` / `GoogleService-Info.plist` into the right native folders automatically. These files are gitignored (see section 9) — you regenerate them locally with this command, you don't pull them from git.

### 5.5 Enable Email/Password authentication

Firebase Console → **Build → Authentication → Get started → Sign-in method** tab → enable **Email/Password**.

### 5.6 Create the Firestore database

Firebase Console → **Build → Firestore Database → Create database** → pick a nearby region → start in test mode (we lock it down in the next step).

### 5.7 Set Firestore security rules

Firebase Console → **Firestore Database → Rules** tab → replace the default with:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /notes/{noteId} {
      allow read, update, delete: if request.auth != null
        && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
    }
  }
}
```

This is the actual security boundary — it enforces "user-specific notes only" server-side, not just via the app's query filter.

### 5.8 Android SDK check

Open `android/app/build.gradle` (or `.kts`) and confirm:

```kotlin
android {
    compileSdk = 35
    defaultConfig {
        minSdk = 23   // firebase_auth requires at least 23
    }
}
```

### 5.9 Run it

```bash
flutter run
```

---

## 6. Project Structure

```
lib/
  core/                  → shared constants, theme, widgets, DI, routing, utils
  features/
    auth/
      domain/ data/ presentation/
    notes/
      domain/ data/ presentation/
  app.dart
  main.dart
```

See section 2 for what goes in each of `domain` / `data` / `presentation`.

---

## 7. Assumptions Made During Development

- **Signup auto-logs the user in** and takes them straight to the dashboard, rather than requiring a separate login after registration. `createUserWithEmailAndPassword` already authenticates the session, so requiring a second login would be redundant friction.
- **Real-time updates are implemented via a Firestore stream consumed by a GetX `.obs` list + `Obx()`**, not a literal `StreamBuilder` widget. The original brief names `StreamBuilder` specifically — functionally this achieves identical real-time behavior (the UI updates live with zero manual refresh, exactly as Firestore pushes changes), but it's the GetX-idiomatic way of consuming a stream rather than the vanilla-Flutter widget. Flagging this explicitly in case it's checked against literally rather than functionally — happy to swap in an actual `StreamBuilder` if that's preferred.
- **Firestore query sorts client-side** (`orderBy` is not used in the Firestore query itself) rather than `.where().orderBy()` server-side, specifically to avoid requiring a composite index to be manually created in the Firebase console — one less manual setup step for whoever runs this.
- **Logout and exiting the app both require confirmation.** Logout via the AppBar icon shows "Log out?" before clearing the session. Pressing back from the dashboard (it's the root screen post-login, nothing left to pop to) shows "Exit app?" rather than silently backgrounding/closing.
- **Starred notes** were added as a tab on the dashboard (All Notes / Starred) — not in the original spec, added on request. Stored as a simple `isStarred` boolean on the note document.
- **No social sign-in (Google/Apple).** These were explored and then deliberately removed — implementing them for real requires OAuth client setup in the Firebase console that wasn't worth the added risk this close to the deadline, and decorative-only buttons that don't work would misrepresent functionality to an evaluator.
- **File/image attachments on notes were explored and then removed** for the same reason — Cloud Storage now requires the Blaze (pay-as-you-go) billing plan even for free-tier usage, which is a real setup step better left as a deliberate future addition than rushed in.

---

## 8. Known Limitations

- No automated tests are included by default, though `bloc_test`/`mocktail` are present in `pubspec.yaml` if you want to add unit tests for `AuthBloc`.
- Desktop platforms (Windows/Linux) will run the UI but `firebase_auth`/`cloud_firestore` aren't officially supported there by FlutterFire — stick to Android/iOS/Web/macOS for actual testing.

---

## 9. .gitignore Notes

`lib/firebase_options.dart`, `google-services.json`, and `GoogleService-Info.plist` are intentionally gitignored — they're regenerated locally via `flutterfire configure` (section 5.4), not committed. This is standard practice for any repo that might end up public, and keeps the README's setup instructions as the actual source of truth rather than a stale committed file.

**If you already ran `git add .` before adding `.gitignore`**, those files may already be tracked — gitignore only prevents *future* additions. Untrack them with:

```bash
git rm --cached lib/firebase_options.dart
git rm --cached android/app/google-services.json
```

---

## 10. Manual Test Walkthrough

1. Sign up with a new email → should land directly on the dashboard with an empty state.
2. Add a note (title required, description optional) → confirm it appears instantly.
3. Star it → switch to the **Starred** tab → confirm it's there.
4. Edit the note → confirm changes save.
5. Delete it → confirm the dialog appears before it's removed.
6. Tap logout → confirm the "Log out?" prompt appears, confirm it actually signs out.
7. Log back in with the same credentials → confirm notes persisted and are scoped to that user.
8. From the dashboard, press back → confirm the "Exit app?" prompt appears instead of silently closing.

---

## 11. Command Reference

**Flutter**

```bash
flutter --version                  # check installed version
flutter doctor                     # check environment setup
flutter pub get                    # install dependencies
flutter clean                      # clear build cache (run if anything behaves oddly after a pull)
flutter analyze                    # static analysis
flutter run                        # run on a connected device/emulator
flutter build apk --release        # build the release APK for submission
flutter build appbundle --release  # build an .aab if a Play Store-style bundle is ever needed
```

Release APK output path after building: `build/app/outputs/flutter-apk/app-release.apk`

**Firebase / FlutterFire**

```bash
npm install -g firebase-tools          # install Firebase CLI
firebase login                         # authenticate
firebase projects:list                 # sanity check you're logged into the right account
dart pub global activate flutterfire_cli
flutterfire configure                  # connect this project to a Firebase project
```
