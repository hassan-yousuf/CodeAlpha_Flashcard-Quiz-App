# Study Cards

A small Flutter flashcard app for reviewing questions and answers. Study a set
of cards, reveal answers with a flip animation, and manage the set directly
from the app.

## Features

- View the current question and reveal its answer.
- Move forwards and backwards through the study set.
- Add new cards with validated question and answer fields.
- Edit or delete the current card.
- Responsive Material 3 interface with Google Fonts.
- Works across Flutter-supported desktop, mobile, and web targets.

## Requirements

- Flutter SDK with Dart `3.12.2` or newer within the Dart 3.x range.
- A configured Flutter device, emulator, simulator, or browser.

Check the local setup with:

```bash
flutter doctor
```

## Getting Started

1. Clone or download the repository.
2. Open the project directory:

	```bash
	cd quizapp
	```

3. Install dependencies:

	```bash
	flutter pub get
	```

4. Start the app on an available device:

	```bash
	flutter run
	```

To target a specific platform, list available devices first:

```bash
flutter devices
flutter run -d chrome       # Web
flutter run -d windows      # Windows desktop
flutter run -d <device-id> # Android, iOS, or another connected target
```

## Usage

The app starts with three sample cards. Use **Show answer** to flip the active
card, then use **Previous** or **Next** to navigate. The add button creates a
card, while the edit and delete actions manage the current card.

Cards are currently stored in memory only. Changes are lost when the app is
restarted.

## Testing

Run the test suite with:

```bash
flutter test
```

Run static analysis with:

```bash
flutter analyze
```

## Project Structure

```text
lib/
├── main.dart                         # Application entry point
├── app.dart                           # Material theme and root widget
├── models/
│   └── flashcard.dart                 # Flashcard data model
├── screens/
│   └── study_cards_page.dart          # Study flow and card management
└── widgets/
	 ├── card_editor_dialog.dart        # Add and edit form
	 └── flashcard_view.dart             # Animated question/answer card
test/
└── widget_test.dart                   # Widget tests
```

## Dependencies

- [Flutter](https://flutter.dev/)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Cupertino Icons](https://pub.dev/packages/cupertino_icons)

## License

This project is for learning and internship use. No license has been specified
yet.

## Author

Built as part of the CodeAlpha App Development Internship.