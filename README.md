# Newspapers

A Flutter news application built with `flutter_bloc`, `go_router`, and NewsAPI.  
The app shows top headlines by category, supports keyword-based news search, opens article details, and automatically routes to an offline screen when internet access is unavailable.

## Current Update

This project was updated from `GetX`-based state handling to a full BLoC-based flow for the active app state.

What changed:

- Removed `GetX` from the app flow.
- Added `HomeBloc` for article loading, search, refresh, and category switching.
- Added `NetworkCubit` for connectivity tracking and offline routing.
- Moved article fetching into `NewsRepository`.
- Decoupled `ApiService` from global `Get.find()` lookups.
- Kept offline navigation, but removed the internet connection popup/snackbar.

## Features

- Category-based top headlines
- Search news by keyword
- Pull-to-refresh on the home feed
- Article details screen
- Offline screen when network is unavailable
- Cached article images
- Environment-based API key loading with `.env`

## Tech Stack

- Flutter
- `flutter_bloc`
- `go_router`
- `connectivity_plus`
- `http`
- `cached_network_image`
- `flutter_dotenv`
- `flutter_svg`

## Project Structure

```text
lib/
  main.dart
  Models/
  Repository/
  Router/
  Services/
  Utils/
  Views/
  bloc/
    home/
    network/
```

Important parts:

- `lib/main.dart`: app bootstrap, bloc providers, router shell
- `lib/bloc/home/`: home feed events, state, and business logic
- `lib/bloc/network/`: connectivity state management
- `lib/Repository/news_repository.dart`: news fetching logic
- `lib/Services/AuthRname/Api_Services.dart`: HTTP layer
- `lib/Router/`: route names and GoRouter setup
- `lib/Views/HomeScreen/`: home UI
- `lib/Views/OfflinePage/`: offline UI

## Architecture

### Home Flow

- `HomeBloc` receives `HomeFetched`
- `NewsRepository` decides whether to call:
  - `/v2/top-headlines` for category-based feed
  - `/v2/everything` for search results
- Loaded articles are emitted through `HomeState`
- UI rebuilds with `BlocBuilder` / `BlocConsumer`

### Network Flow

- `NetworkCubit` watches connectivity changes
- Internet access is verified before marking the app online
- The app routes to:
  - `home` when online
  - `offline` when offline

## Categories

Current home categories:

- Business
- Tech
- Entertainment

## API Configuration

This app uses NewsAPI.

Create a `.env` file in the project root:

```env
API_KEY=your_newsapi_key_here
```

The app reads the key from:

- `lib/Utils/AppConstant/app_constant.dart`

Base URL:

```text
https://newsapi.org
```

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Add environment file

Create `.env` in the project root and set:

```env
API_KEY=your_newsapi_key_here
```

### 3. Run the app

```bash
flutter run
```

## Useful Commands

Run tests:

```bash
flutter test
```

Run analyzer:

```bash
flutter analyze
```

Format code:

```bash
dart format lib test
```

## Screens

- Home screen
  Shows category chips, search input, and article list
- Article details screen
  Opens selected article data passed through the router
- Offline screen
  Shown automatically when no internet connection is available and uses the app icon as the offline illustration

## Recent Notes

- The app no longer shows a "No Internet Connection" popup.
- Offline handling is route-based now and sends the user to the offline page when internet is unavailable.
- The offline screen uses the app icon instead of a separate offline popup icon.
- `GetX` controllers for home and network handling were removed.

## Verification

Current basic verification used during the update:

```bash
flutter test test/widget_test.dart
```

## Known State

The app is functionally migrated to BLoC, but the repository still contains some existing analyzer warnings unrelated to the migration, mainly naming and older utility/service issues.
