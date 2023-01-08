# smart_naka

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Setting up the project in your local environment💻

<p align="center">
    <img src="https://user-images.githubusercontent.com/74055102/141175363-4c00515a-2658-475e-b510-394110d43ec5.png" height=400/>
</p>

1. [Fork](https://github.com/mauryakshitij/Smart-Naka/fork) this repository.
2. Clone the **forked** repository:
```
git clone https://github.com/<your username>/Smart-Naka
cd Smart-Naka
```
3. Add a remote to the upstream repository:
```
# Typing the command below should show you only 1 remote named origin with the URL of your forked repository
git remote -v
# Adding a remote for the upstream repository
git remote add upstream https://github.com/mauryakshitij/Smart-Naka
```
4. Get [Flutter](https://docs.flutter.dev/get-started/install) and [Firebase CLI](https://firebase.google.com/docs/cli?authuser=0&hl=en#install_the_firebase_cli) if you don't already have them.
5. Run `flutter pub get` to get the dependencies.
6. If you have not yet logged into `Firebase CLI` and activate `FlutterFire CLI` globally:
```
firebase login
dart pub global activate flutterfire_cli
```
7. Create a new project on [Firebase Console](https://console.firebase.google.com/), activate Google Sign In, and activate Firebase Firestore in **test mode**.
8. Configure your flutter app with the newly created project on firebase console:
```
flutterfire configure
```

This automatically registers your per-platform apps with Firebase and adds a `lib/firebase_options.dart` configuration file to your Flutter project.

9. Finally, run the app:
```
flutter run
```
As we have used API that doesn't contain numbers of Indian vehicles so here are some Examples: CT529663, CA529663.

# Authors

This project was developed under a hackathon by

- [Yash Raj Singh](https://github.com/Yash-jar)
- [Kshitij Maurya](https://github.com/mauryakshitij)
- [Gholap Sarvesh Sarjerao](https://github.com/sarg19)
