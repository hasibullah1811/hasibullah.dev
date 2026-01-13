# Minimalist Developer Portfolio ⚡️

A clean, document-style portfolio website built with **Flutter Web**. 
Designed for developers who prefer content, code, and clarity over flashy animations.

## 🚀 Live Demo
[https://hasibullah.dev]

## ✨ Features

* **Terminal Aesthetic:** Uses `JetBrains Mono` for that authentic coding environment feel.
* **Theme Toggle:** Seamless switching between **Dark Mode** (Hacker style) and **Light Mode** (Paper style).
* **Responsive Design:** Looks like a document on Desktop, adapts natively to Mobile.
* **Custom Sections:**
    * **LeetCode Stats:** Visual progress bars for competitive programming.
    * **Timeline:** Vertical timeline for Education history.
    * **Publications:** Academic citation style layout.
    * **Tech Stack:** Grid layout for skills.
* **Personality:** Includes a "Production Engineer (Kebabs)" role to show resilience and humor.

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Fonts:** [Google Fonts](https://pub.dev/packages/google_fonts) (JetBrains Mono & Playfair Display)
* **Icons:** [FontAwesome](https://pub.dev/packages/font_awesome_flutter)

## 📦 Installation & Setup

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/hasibullah1811/hasibullah.dev.git](https://github.com/hasibullah1811/hasibullah.dev.git)
    cd hasibullah.dev
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run locally (Web)**
    ```bash
    flutter run -d chrome
    ```

4.  **Build for Production**
    ```bash
    flutter build web --release
    ```

## 🎨 Customization

The entire content is currently located in `lib/main.dart` for simplicity. To personalize this for yourself:

1.  **Update Personal Info:** Look for the `HeaderSection` class to change the bio and name.
2.  **Update Projects:** Modify the `ProjectItem` widgets in the `PortfolioHome` list.
3.  **Update Colors:** Change the `ColorScheme` in the `ThemeData` block inside `main()`.

## 🤝 Credits & Inspiration

* **Design Inspiration:** [Aditya Kumar](https://adityak.dev) - The layout was heavily inspired by his minimalist portfolio concept.
* **Developed by:** [Hasib Ullah](https://github.com/hasibullah1811)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).