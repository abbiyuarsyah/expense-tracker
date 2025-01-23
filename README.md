# Expense Tracker

The Personal Expense Tracker App is designed to help users effectively track their expenses. It allows users to keep track of their spending, categorize expenses, and view them in an organized manner.

https://github.com/user-attachments/assets/50d26908-5c9e-482e-81b0-32ac61e2d7f3


## How To Run the App 

Follow these steps to set up and contribute to the project:

1. **Clone the Repository**
   
   ```bash
   git clone 
2. **Install Dependencies**
   
   ```bash
   flutter pub get
3. **Run the app**

   ```bash
   flutter run
   
## How To Run the test 

Follow these steps to run the test:

1. **Unit and Wiget Test**
   
   ```bash
   flutter test
2. **Integration Test**
   
   ```bash
   flutter drive \--driver=test_driver/integration_test.dart \--target=integration_test/app_test.dart 

## Test
This app includes comprehensive testing with two types of tests: widget tests and unit tests. The implemented tests cover various aspects, including data sources, BLoC, extensions, states, and core business logic.

## Folder Structure
This project follows the Clean Code Architecture integrated with Bloc State Management for efficient and scalable application development.
The detailed code structure is outlined below:

```plaintext
lib/
├── core/                         # Contains shared code used across the app.
│   ├── constants/                # Defines app-wide constants, such as strings, and other static values.
│   ├── enums/                    # Contains enumerations used for categorization or state management.
│   ├── extensions/               # Provides custom Dart extensions to add utility methods to existing classes.
│   ├── service_locator/          # Contains the service locator for dependency injection.
│   ├── shared_widget/            # Houses reusable widgets that are shared across multiple features.
│   ├── utils/                    # Utility functions, such as date parsers, formatters, or custom validators.
├── features/                     # Contains the implementation of app features, structured modularly.
│   ├── feature_name/             # Placeholder for a specific feature's code.
│   │   ├── data/                 # Contains data-related code for the feature.
│   │   │   ├── datasources/      # Defines remote and local data sources (e.g., APIs, databases).
│   │   │   ├── models/           # Data models that map JSON responses or database entities.
│   │   │   └── repositories/     # Implements the domain's repository contracts for data management.
│   │   ├── domain/               # Contains business logic and definitions for the feature.
│   │   │   ├── entities/         # Core business objects with only essential fields and properties.
│   │   │   ├── repositories/     # Abstract definitions of the repositories used by the domain layer.
│   │   │   └── use_case/         # Encapsulates specific business logic for the feature.
│   │   └── presentation/         # Handles UI and state management for the feature.
│   │       ├── bloc/             # Bloc files for state management (events, states, blocs).
│   │       ├── pages/            # Flutter screens/pages for this feature.
│   │       └── widgets/          # Reusable UI widgets specific to the feature.
├── app.dart                      # Main app widget that initializes and configures the app.
└── main.dart                     # Application entry point, contains the `main()` function.
test/
├── core/                         # Core unit tests
├── presentation/                 # Includes unit and widget tests related to app flow and states
integration_test/                 # Contains integration tests

```

## Libraries
```plaintext
  dartz:                    # Implements functional programming tools for managing side effects and error handling.
  easy_localization:        # Supports multiple languages for localization and translation.
  equatable:                # Compares objects by value, useful for managing state with flutter_bloc
  flutter_bloc:             # Manages state using the BLoC pattern, separating business logic from UI.
  get_it:                   # Service locator for managing and injecting dependencies across the app
  hive:                     # Local database for persisting expense data
  intl:                     # Formats dates, numbers, and currencies according to the user’s locale.
  mockito:                  # Used for mocking objects in unit and widget tests.
  path:                     # Manages file and directory paths for file storage.
  path_provider:            # Provides access to common directories for storing data.
```
