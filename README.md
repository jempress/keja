# Keja App (Flutter)

Renter + agent app for Keja, talking to the [Keja backend](../keja-backend).

## ⚠️ Important — read before running

This project was authored file-by-file in a sandbox **without the Flutter SDK or
Android/iOS toolchains installed**, so none of this has been run through
`flutter pub get`, `flutter analyze`, or `flutter build` yet. The code follows
Flutter/Dart conventions carefully, but you should treat it as a solid
first draft, not a verified build. Concretely, before you rely on it:

1. **Generate the native platform folders.** `android/`, `ios/`, `web/` etc.
   are not included — they're toolchain-generated (Gradle/Xcode project files
   aren't safe to hand-author). Run:
   ```bash
   flutter create --project-name keja_app --org com.keja .
   ```
   in this directory. It will scaffold `android/`, `ios/`, etc. **without**
   touching the existing `lib/`, `pubspec.yaml`, or `test/` — confirm that's
   still true for whatever Flutter version you're on, and back up first if
   unsure.

2. **Run `flutter pub get` and `flutter analyze`** and fix whatever surfaces.
   Dependency versions in `pubspec.yaml` were current as of early/mid 2024
   knowledge — bump anything outdated with `flutter pub outdated`.

3. **google_maps_flutter needs API keys** added natively (`AndroidManifest.xml`
   `<meta-data android:name="com.google.android.geo.API_KEY">`, and the iOS
   equivalent in `AppDelegate.swift`) once step 1 generates those files.

4. **The map view is a placeholder** (`_MapPlaceholder` in `browse_screen.dart`)
   — swap it for a real `GoogleMap` widget plotting listings' lat/lng once
   the API key is wired up.

5. **Chat bubble left/right styling** doesn't yet compare `message.senderId`
   to the logged-in user's id — see the `NOTE` in `chat_screen.dart`.

## Structure

```
lib/
  main.dart, app.dart        Entry point, theme + auth-gated routing
  theme/app_theme.dart       Colors matching the mockups (verified-stamp green, etc.)
  config/api_config.dart     Backend base URL (--dart-define=API_BASE_URL=...)
  models/                    Listing, Agent, AppUser, Conversation, ChatMessage
  services/                  One per backend resource (auth, listings, agents,
                              favorites, chat, payments, uploads) + a shared
                              Dio client that injects the JWT
  providers/auth_provider.dart  App-wide login state
  screens/
    auth/                   Phone entry -> OTP
    browse/                 Search + list/map toggle
    listing/                Listing detail + contact-agent
    saved/                  Favorited listings
    chat/                   Inbox + conversation thread, location sharing
    agent/                  Dashboard, post-listing form, verification,
                            subscription (M-Pesa + bank transfer)
    shared/                 Bottom-nav shell, role-aware (agent tab only
                            shows for agent accounts)
test/widget_test.dart        Model + smoke tests (kept free of platform
                              channels like secure storage/geolocator so
                              they run in CI without extra setup)
```

## Running locally

```bash
flutter create --project-name keja_app --org com.keja .   # once, see above
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000   # Android emulator -> host
# or, for a physical device on the same network as your backend:
flutter run --dart-define=API_BASE_URL=http://<your-machine-ip>:4000
```

## CI/CD — GitHub Actions + Firebase App Distribution

`.github/workflows/flutter-ci-cd.yml` does two things:

- **Every push/PR to `main`**: `flutter pub get`, `flutter analyze`, `flutter test`
- **On push to `main` only**: builds a release APK *in the Actions runner*
  (that's the "compile in GitHub Actions" part), then uploads it to Firebase
  App Distribution for your testers group

### Secrets to set (repo Settings → Secrets and variables → Actions)

| Secret | What it is |
|---|---|
| `API_BASE_URL` | Your deployed backend's URL, e.g. `https://api.keja.co.ke` — baked into the APK at build time |
| `FIREBASE_ANDROID_APP_ID` | From Firebase Console → Project settings → your Android app → App ID (looks like `1:1234567890:android:abcd1234`) |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | A Firebase service account key with **Firebase App Distribution Admin** role, full JSON content pasted as the secret value |

### One-time Firebase setup

1. In [Firebase Console](https://console.firebase.google.com), create a project (or reuse one) and add an Android app — this gives you the App ID above.
2. **Project settings → Service accounts → Generate new private key** — downloads a JSON file. Paste its full contents into the `FIREBASE_SERVICE_ACCOUNT_JSON` secret.
3. **App Distribution → Testers & groups** — create a group named `testers` (or change `groups:` in the workflow to match).
4. Push to `main` — the workflow builds and your testers get an email/notification with the new build.

### iOS distribution (not yet wired up)

The workflow only builds Android for now. iOS builds need a macOS runner
(`runs-on: macos-latest`), a code-signing certificate + provisioning profile
stored as secrets, and `flutter build ipa`. Worth adding once you're ready
to test on iPhones — happy to add that job when you get there.
