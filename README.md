# 🚀 Survey App

Full-stack survey platform built with **Node.js (backend)** and **Flutter Web (frontend)**.


# 📦 Project Structure
/backend → Node.js API (already deployed)

/frontend → Flutter Web app



# 🌐 Backend (Already Deployed)

The backend is already deployed and does not require any local setup.

## 🔗 API Base URL
https://survey-app-trusca-daria.onrender.com


✔ No installation required  
✔ No database setup required  


# 📱 Frontend Setup (Flutter Web)

## 1. Install Flutter

Follow official installation guide:

👉 https://docs.flutter.dev/get-started/install

### Recommended setup:
- Flutter SDK
- VS Code
- Flutter & Dart extensions


## 2. Verify installation

```bash
flutter doctor
```

Make sure all checks pass.

## 3. Install dependencies

```bash
cd frontend/survey_app_flutter
flutter pub get
```

## 4. Run the app (Chrome)

### 🟢 VS Code Launch Configuration (Chrome Custom Port)

Add the following configuration to your `.vscode/launch.json` file:

```json
{
  "name": "survey_app_flutter (chrome custom port)",
  "cwd": "frontend\\survey_app_flutter",
  "request": "launch",
  "type": "dart",
  "program": "lib/survey_app.dart",
  "args": [
    "-d",
    "chrome",
    "--web-port",
    "5000"
  ]
}
```

#### ▶️ How to run

1. Open VS Code  
2. Go to **Run & Debug**  
3. Select:  
   ```
   survey_app_flutter (chrome custom port)
   ```
4. Click **Run**

### 🟡 Run via Terminal

Run the Flutter web app using Chrome on a custom port:

```bash
flutter run -d chrome --web-port 5000 -t lib/survey_app.dart
```
