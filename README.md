# Flutter Therapy Evolution

A Flutter application for speech therapy and clinical management, designed with an MVVM architecture approach and modern design patterns.

## Project Overview

Flutter Therapy Evolution is a comprehensive application for speech therapists to manage patients, appointments, clinical records, and consultations. The application leverages Firebase for authentication and data storage and follows modular design principles.

## Architecture

The project follows a Flutter-recommended architecture approach with a modular structure:

[Flutter Architecture Guide](https://docs.flutter.dev/app-architecture/guide)

[Flutter Compass App Example](https://github.com/flutter/samples/tree/main/compass_app)




### Core Principles

- **Modular Design**: Using Flutter Modular for dependency injection and routing
- **MVVM Architecture**: Separation of concerns with distinct layers
- **Command Pattern**: For encapsulating and managing asynchronous operations
- **Result Pattern**: For handling success/failure scenarios using Result data type

### Project Structure

```
lib/
├── app/
│   ├── core/            # Core functionality and shared components
│   │   ├── alert/       # Alert and dialog utilities
│   │   ├── command/     # Command pattern implementation
│   │   ├── entities/    # Core domain entities
│   │   ├── errors/      # Error handling
│   │   ├── extensions/  # Dart extensions
│   │   ├── log/         # Logging utilities
│   │   ├── repositories/# Base repository interfaces
│   │   ├── session/     # User session management
│   │   ├── typedefs/    # Common type definitions
│   │   └── widgets/     # Shared widgets
│   │
│   ├── features/        # Application features
│       ├── auth/        # Authentication feature
│       ├── patient/     # Patient management feature
│       ├── appointment/ # Appointment scheduling feature
│       ├── clinical_record/ # Clinical records feature
│       ├── consultation/# Consultation management feature
│       ├── home/        # Home screen feature
│       └── splash/      # App splash screen
│
├── design_system/       # Design system package with UI components
├── firebase_options.dart# Firebase configuration
└── main.dart            # Application entry point
```

### Feature Structure

Each feature follows a consistent structure:

```
feature/
├── data/                # Data layer
│   ├── repositories/    # Repository interfaces and implementations
│   └── models/          # Data models
│
├── domain/              # Domain layer
│   ├── entities/        # Domain entities
│   └── usecases/        # Use cases implementing business logic
│
├── presentation/        # Presentation layer
│   ├── pages/           # UI pages
│   ├── view_models/     # View models with Command pattern
│   └── widgets/         # Feature-specific widgets
│
└── feature_module.dart  # Feature module definition for routing and DI
```

## Command Pattern

The project uses a custom Command pattern implementation to handle asynchronous operations and state management:

### Key Components

- `Command<T>`: Base abstract class for all commands
- `Command0<T>`: Command without arguments
- `Command1<T, A>`: Command with one argument
- `CommandStream<T>`: Command that handles streams

### Usage Example

```dart
// In a view model
class PatientViewmodel {
  final IPatientRepository _repository;

  PatientViewmodel(this._repository) {
    savePatientCommand = Command1(_repository.savePatient);
  }
  late final Command1<Unit, PatientEntity> savePatientCommand;
}

// In a widget
ListenableBuilder(
  listenable: viewModel.savePatientCommand,
  builder: (context, _) {
    return CustomButton(
        isLoading: viewModel.savePatientCommand.running,
        title: 'Save',
        onPressed: () {
            final patientRecord = PatientEntity();
            await viewModel.savePatientCommand.execute(patientRecord);
        }
    );
  },
),

```



## Result Pattern

The application leverages the `result_dart` package to handle operation results:

```dart
// Return success or failure
Output<Patient> savePatient(Patient patient) async {
  try {
    final result = await patientRepository.save(patient);
    return Success(result);
  } catch (e) {
    return Failure(PatientException(message: 'Failed to save patient'));
  }
}

// Handle the result
final result = await savePatient(patient);
result.fold(
  (patient) => showSuccess('Patient saved successfully'),
  (error) => showError(error.message),
);
```

## Getting Started

### Prerequisites

- Flutter SDK 3.6.1 or higher
- Dart SDK 3.6.1 or higher
- Firebase project configured

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/flutter_therapy_evolution.git
cd flutter_therapy_evolution
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run
```

## Development Tools

- **Mason**: For code generation and templating
  - `feature`: Template for creating new features
  - `feature_crud`: Template for creating CRUD features

## Libraries and Dependencies

- `flutter_modular`: For dependency injection and routing
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Firebase services
- `result_dart`: For functional error handling
- `shared_preferences`: For local storage
- `logger`: For logging
- `intl`: For internationalization
- `uuid`: For generating unique identifiers

## License

This project is licensed under the BSD License - see the LICENSE file for details.
