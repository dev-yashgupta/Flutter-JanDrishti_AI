# 🏥 SehatVanni AI — Citizen Portal Mobile App

A modern, cross-platform mobile & web application built with **Flutter 3** and **Dart**, replicating and expanding the **SehatVanni AI Citizen Portal**.

---

## 🌟 Overview

The **SehatVanni AI Citizen Portal** bridges the gap between citizens, certified doctors, and AI-powered diagnostic tools. Designed with a clean, patient-centric UI and a healthcare-focused teal theme, it delivers:
* Real-time doctor search & slot booking.
* AI-assisted disease screening (Pneumonia, Cardiovascular Risk, and Cancer Risk).
* Generic medicine cost-saving substitute finder (up to 85% savings).
* Digital prescription repository with dosages & physician instructions.
* Emergency SOS hotline dispatch & comprehensive vital sign tracking.
* Direct AI Health Assistant conversational triage.

---

## 🚀 Key Features

### 1. 🔐 Authentication & Security
* **Firebase Authentication**: Email & password authentication with automatic ID token generation.
* **Instant Demo Login**: One-tap quick login pre-configured with test credentials:
  * **User ID / Email**: `citizen1@test.com`
  * **Password**: `password`
* **Citizen Registration Wizard**: Easy registration storing profile information securely in Firestore.
* **Resilient Startup**: Built-in fallback to ensure the app never crashes or displays a blank screen if network is unavailable.

### 2. 📊 Dynamic Citizen Dashboard
* **Personalized Greeting**: Time-aware greetings with user display name.
* **Real-time Status Counter**: Live counts of upcoming, completed, and pending appointments.
* **Quick Action Buttons**: Fast shortcuts to book appointments, search specialists, chat with AI, and access records.
* **Citizen Health & AI Hub**: Interactive multi-card hub linking to specialized diagnostic & pharmacy utilities.

### 3. 📅 Appointment Booking & Management
* **Interactive Appointment Wizard**:
  * Filter doctors by specialty chips (Cardiology, Dermatology, Orthopedics, Pediatrics, etc.).
  * Interactive Calendar Date Picker with past-date prevention.
  * Time slot selection chips.
  * Booking confirmation summary with note attachment.
* **Appointment Tracking**:
  * Tabbed categories: **Upcoming**, **Past**, and **All**.
  * Color-coded status badges: `Confirmed`, `Pending`, `Cancelled`, `Completed`.
  * Dialog-confirmed cancellation with instant status update.

### 4. 👨‍⚕️ Doctor Directory & Detail
* **Smart Search**: Filter specialists by name, specialty, or hospital affiliation.
* **Doctor Profile Cards**: Experience years, rating with star badges, review counts, available days, and consultation slots.
* **Detailed View**: Qualifications (MBBS, MD, DM), full biography, working clinic location, and direct "Book Appointment" CTA.

### 5. 🤖 Conversational AI Health Assistant
* **Smart Symptom Assistant**: Interactive medical chatbot powered by `/api/ai/chat`.
* **Contextual History**: Keeps track of recent conversation exchanges.
* **Quick Prompts**: One-tap suggestion chips for common medical concerns.
* **Clinical Fallback Engine**: Local heuristic medical advice when backend is unreachable.

### 6. 🔬 AI Disease Diagnostics Center
* **Pneumonia & Respiratory Screener**:
  * Evaluates fever, persistent cough, dyspnea, and symptom duration.
  * Generates clinical probability percentage, risk category, and action steps.
* **Cardiovascular Risk Calculator**:
  * Framingham-aligned assessment computing blood pressure, total cholesterol, age, smoking status, and diabetes.
* **Breast Cancer Early-Risk Evaluation**:
  * Screens genetic history, firm lump presence, and somatic symptoms with direct doctor referral.

### 7. 💊 Generic Medicine Substitutes
* **Brand to Generic Translation**: Search brand medications (*Lipitor, Augmentin, Glucophage, Nexium, Norvasc*, etc.).
* **Cost Savings Estimator**: Highlights generic price comparisons with up to 85% patient savings.
* **Active Salt & Formulation**: Details active ingredients, recommended dosage, and usage warnings.

### 8. 📋 Digital Prescriptions & Pharmacy Integration
* **Doctor Orders**: Displays physician name, specialty, diagnosis, and prescription date.
* **Dosage Schedule**: Itemized table showing medicine name, dosage, frequency, duration, and meal instructions.
* **PDF Download Action**: One-tap prescription export.
* **Substitute Shortcut**: Jump straight into the generic finder for each prescribed drug.

### 9. 🩺 Vitals & Emergency SOS
* **Emergency Dispatch**: High-visibility SOS card triggering emergency medical dispatch (108 / 112).
* **Vitals Tracker**: Logs and monitors:
  * Blood Pressure (Systolic / Diastolic)
  * Heart Rate (BPM)
  * Blood Oxygen (SpO2 %)
  * Blood Glucose (mg/dL)
  * Body Temperature (°F)
* **Clinical Range Badges**: Compares values against standard physiological ranges.

### 10. 📁 Medical Records & Profile Management
* **Record Vault**: Organized storage for Blood Test Reports, Chest X-Rays, and ECG scans.
* **Profile Settings**: Edit contact number, date of birth, blood group, and residential address.

---

## 🧩 Flutter Widgets & Component Hierarchy

The application follows clean architecture principles with reusable, decoupled widgets:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Medical teal palette, gradients, and shadows
│   │   └── app_strings.dart        # Unified string constants & API routes
│   ├── models/
│   │   ├── appointment_model.dart  # Data model for bookings with status getters
│   │   ├── doctor_model.dart       # Doctor bio, qualification, and slot model
│   │   └── user_model.dart         # Citizen profile model with copyWith
│   └── services/
│       ├── api_service.dart        # HTTP client with Bearer auth & offline fallback
│       └── auth_service.dart       # Firebase Authentication wrapper
├── navigation/
│   └── main_navigation.dart        # Persistent BottomNavigationBar with 5 tabs
├── screens/
│   ├── ai_assistant/               # Conversational AI assistant
│   ├── appointments/               # List appointments & Booking wizard
│   ├── auth/                       # Login & Registration screens
│   ├── dashboard/                  # Home dashboard with Health Hub
│   ├── diagnostics/                # Pneumonia, Heart, and Cancer AI screeners
│   ├── doctors/                    # Specialty directory & doctor detail
│   ├── medical_records/            # Lab & Radiology reports
│   ├── medicines/                  # Generic medicine substitute finder
│   ├── prescriptions/              # Digital prescription list & dosage cards
│   ├── profile/                    # Personal & health settings
│   └── vitals/                     # Vitals tracker & Emergency SOS
└── widgets/
    ├── appointment/                # AppointmentCard with status badges
    ├── common/                     # CustomAppBar & LoadingWidget
    ├── doctor/                     # DoctorCard with rating & booking button
    └── home/                       # HealthCardWidget & QuickActionWidget
```

---

## 🛠️ Tech Stack & Dependencies

| Package | Version | Purpose |
|:---|:---|:---|
| **Flutter SDK** | `^3.12.0` | Cross-platform framework (Android, iOS, Web) |
| **firebase_core** | `^4.15.0` | Firebase initialization & app configuration |
| **firebase_auth** | `^6.7.0` | Secure user authentication & token streaming |
| **cloud_firestore** | `^6.10.0` | Citizen profile persistence & cloud database |
| **http** | `^1.2.2` | REST API communication with Next.js backend |
| **intl** | `^0.20.2` | Date formatting and localized displays |
| **shared_preferences** | `^2.3.2` | Local device preferences caching |
| **cached_network_image** | `^3.4.1` | Efficient image caching for doctor avatars |
| **flutter_svg** | `^2.0.10+1` | Crisp vector graphic rendering |
| **cupertino_icons** | `^2.0.0` | Additional system icons |

---

## 🔌 Backend API Endpoints

The app communicates with the SehatVanni AI platform at `https://health-bridge-ai.vercel.app/api`:

* **`GET /api/appointments`**: Retrieves user appointments list.
* **`POST /api/appointments`**: Schedules a new appointment with concurrency checks.
* **`PUT /api/appointments/:id/cancel`**: Cancels an active appointment.
* **`GET /api/doctors`**: Fetches specialist doctor directory (supports `?specialty=` filter).
* **`POST /api/ai/chat`**: Conversational AI query endpoint with chat history.
* **`GET /api/profile`**: Fetches authenticated citizen profile details.
* **`PUT /api/profile`**: Updates citizen demographic and health information.

---

## 💻 Getting Started & Running

### Prerequisites
* Flutter SDK (3.22+ recommended)
* Android Studio / VS Code with Flutter extension
* Android device, emulator, or Google Chrome for web

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Validate Static Analysis
```bash
flutter analyze
```

### Step 3: Run Widget Tests
```bash
flutter test
```

### Step 4: Run the Application

**On Android Device or Emulator:**
```bash
flutter run
```

**On Web (Chrome):**
```bash
flutter run -d chrome
```

---

## 🧑‍💻 Demo Credentials

To test the application immediately without registration:
* **Email**: `citizen1@test.com`
* **Password**: `password`

*(Or simply tap the **"Demo Login"** button on the Login Screen)*
