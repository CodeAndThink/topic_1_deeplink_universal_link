# topic_1_deeplink_universal_link

A new Flutter project to demonstrate Deep Links and Universal Links.

![Demo](demo.gif)

## Prerequisites

- Flutter SDK
- Android Studio

## Installation

```bash
flutter pub get
```

## Running the App

```bash
flutter run
```

## Testing Deep Links & Universal Links

### Android

Run the following command in your terminal while the emulator is running:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "https://prokesdex.vercel.app/pokemon/4" com.example.topic_1_deeplink_universal_link
```

Or open the URL in your notes app: https://prokesdex.vercel.app/pokemon/4