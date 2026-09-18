# CashTrack

CashTrack is a Flutter daily expense manager with offline SQLite storage, AdMob, Firebase Analytics, charts, PDF export and an optional authenticated admin WebView.

## Setup

1. Install Flutter and Android Studio.
2. Create a Flutter project or use this source folder.
3. Run `flutter pub get`.
4. Add your Firebase Android configuration (`google-services.json`) through Firebase setup.
5. Configure Firebase Analytics.
6. Replace the AdMob test IDs in `lib/services/ads_service.dart` with your production IDs.
7. Configure `adminUrl` in `lib/screens/admin_panel_screen.dart` to point to your authenticated admin web dashboard.
8. Run `flutter run`.
9. Build with `flutter build apk --release`.

## Important

The AdMob IDs in this starter project are Google's test IDs. Do not use test IDs for production monetization.

Do not embed Firebase service-account credentials, private keys, or Firebase Console login credentials in the mobile application.

## GitHub

Upload the entire project folder to a new GitHub repository. Do not upload:
- `build/`
- `.dart_tool/`
- local signing keys
- `google-services.json` if your repository is public and you do not understand the exposure implications
