# Joritna Mobile App

Joritna is a privacy-first residential community mobile application for apartment buildings.

The app allows tenants and managers to communicate inside their own building community without exposing private phone numbers or personal social media accounts.

## Features

- Secure login
- Tenant dashboard
- Building join flow
- Building information
- Share & Help community posts
- Comments
- Image upload support
- User avatars
- Role-based navigation foundation

## Tech Stack

- Flutter
- Dart
- Riverpod
- GoRouter
- Dio
- Flutter Secure Storage
- REST API integration
- Joritna Spring Boot microservices backend

## Environment Configuration

The app requires API URLs to be passed at runtime.

### Local development

```bash
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api \
  --dart-define=WEB_SOCKET_BASE_URL=ws://10.0.2.2:8080