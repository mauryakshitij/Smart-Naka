# Smart-Naka
<p  align="center">
<a  href="https://flutter.dev"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487266-9604e883-3bd3-45a5-b172-f4617d911ee3.png"  alt="Flutter Logo"></a> <a>&nbsp;&nbsp;&nbsp;</a>
<a  href="https://dart.dev/"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487289-bd04321b-3f3a-431d-9c29-7e8e4a22d43f.png"  alt="Flutter Logo"></a> <a>&nbsp;&nbsp;&nbsp;</a>
<a  href="https://firebase.google.com/"  target="_blank"><img  height="39"  src="https://user-images.githubusercontent.com/37345795/205487145-a7ad5e40-71e1-46d5-a828-ef82ee168885.png"  alt="Appwrite Logo"></a>
</p>

We have created  a mobile app that allows a constable to quickly and easily check the details of a suspicious vehicle in real time using the dataset present in https://stolenvehicles.co.za/. This database contains information about stolen vehicles, and the goal of the mobile app is to allow the constable to access this information while on patrol, so that they can take appropriate action if a suspicious vehicle is found. To do this, the mobile app communicates with the dataset  through an API (Application Programming Interface) in order to retrieve the necessary information.

## Setting up the project in your local environment💻

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
6. Finally, run the app:
```
flutter run
```
As we have used API that doesn't contain numbers of Indian vehicles so here are some Examples: CT529663, CA529663.

# Authors

This project was developed under a hackathon by

- [Yash Raj Singh](https://github.com/Yash-jar)
- [Kshitij Maurya](https://github.com/mauryakshitij)
- [Gholap Sarvesh Sarjerao](https://github.com/sarg19)
