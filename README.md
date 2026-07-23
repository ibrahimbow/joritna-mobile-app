# Joritna Mobile App

<p align="center">
  <img src="assets/icons/app_icon.png" alt="Joritna Logo" width="160"/>
</p>

<p align="center">
  <strong>A privacy-first residential community platform for tenants and building managers.</strong>
</p>

---

## Overview

Joritna is a modern mobile application that simplifies communication and community management within residential buildings.

Instead of relying on public messaging platforms or paper notices, Joritna provides a secure, building-specific environment where residents and managers can communicate, share information, and stay connected.

The application is designed with privacy, simplicity, and scalability in mind and is built using enterprise-grade architecture.

---

# Features

## Tenant

* Secure authentication
* Automatic login/session restoration
* Join a building using a unique building code
* Leave a building
* View building information
* Receive announcements
* Community chat
* Share & Help community posts
* Comment on posts
* Upload images
* User profile management
* Change password
* Firebase push notifications
* Real-time updates

---

## Building Manager

* Secure authentication
* Create a building
* Update building information
* View building details
* View building tenants
* Remove tenants
* Publish announcements
* Receive notifications
* Profile management
* Change password

---

# Technology Stack

## Mobile

* Flutter
* Dart
* Riverpod
* GoRouter
* Dio
* Flutter Secure Storage
* Firebase Cloud Messaging

---

## Backend

* Java
* Spring Boot
* Spring Security
* Spring Cloud Gateway
* PostgreSQL
* Kafka
* WebSocket
* Docker

---

# Architecture

Joritna Mobile follows a feature-first architecture inspired by Clean Architecture and SOLID principles. Each feature is organized independently, allowing the application to remain scalable, maintainable, and easy to test.

```text
lib/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── community/
│   │   ├── chat/
│   │   ├── files/
│   │   └── share_and_help/
│   │
│   ├── manager/
│   │   ├── announcements/
│   │   ├── building/
│   │   ├── building_tenants/
│   │   ├── dashboard/
│   │   ├── settings/
│   │   └── tenants/
│   │
│   ├── notifications/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── shared/
│   │   └── presentation/
│   │       ├── dashboard/
│   │       ├── layout/
│   │       ├── settings/
│   │       └── widgets/
│   │
│   └── tenant/
│       ├── announcements/
│       ├── building/
│       ├── dashboard/
│       └── settings/
│
├── firebase_options.dart
└── main.dart
```

## Architecture Principles

Joritna Mobile is designed using modern enterprise development practices:

- Feature-first architecture
- Separation of concerns
- SOLID principles
- Clean Architecture concepts
- Repository Pattern
- Riverpod for state management
- GoRouter for navigation
- Dio for REST communication
- Firebase Cloud Messaging for push notifications
- Secure JWT token storage
- Reusable shared presentation components
- Modular and scalable feature organization

## Feature Overview

### Authentication
Handles user authentication, session restoration, and authentication-related business logic.

### Community
Provides shared community functionality available to both tenants and managers, including:

- Community Chat
- Share & Help
- File handling

### Tenant
Contains tenant-specific screens and functionality such as:

- Dashboard
- Building
- Announcements
- Settings

### Manager
Contains manager-specific functionality including:

- Dashboard
- Building management
- Tenant management
- Announcements
- Settings

### Notifications
Manages Firebase push notifications, notification navigation, and notification state.

### Profile
Responsible for user profile management, personal information, and account updates.

### Shared
Contains reusable UI components shared across the application, including layouts, dashboards, settings pages, and common widgets.

The project follows:

* Clean Architecture
* SOLID Principles
* Repository Pattern
* Dependency Injection with Riverpod
* Feature-first organization
* Separation of Presentation, Domain and Data layers

---

# Security

Joritna prioritizes user privacy and security.

* JWT Authentication
* Secure token storage
* HTTPS communication
* Firebase Cloud Messaging
* Role-based authorization
* Private building communities
* No public user discovery

---

# Screenshots

The following screenshots will be included in the Play Store release:

* Login
* Tenant Dashboard
* Building Details
* Announcements
* Community Chat
* Share & Help
* Manager Dashboard
* Tenant Management

---

# Requirements

* Flutter 3.35+
* Dart 3.x
* Android Studio
* Firebase project
* Java 21
* Running Joritna backend

---

# Getting Started

Clone the repository:

```bash
git clone https://github.com/ibrahimbow/joritna-mobile-app.git
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

---

# Build Release

Generate the Android App Bundle:

```bash
flutter build appbundle --release
```

Generate the APK:

```bash
flutter build apk --release
```

---

# Static Analysis

Run the analyzer:

```bash
flutter analyze
```

Format the project:

```bash
dart format .
```

---

# Testing

Run all tests:

```bash
flutter test
```

The MVP focuses on validating:

* Authentication
* Building onboarding
* Announcements
* Chat
* Share & Help
* Push notifications
* Manager workflows

---

# Release Status

Current version:

**v1.0.0**

Current stage:

**Release Hardening**

Remaining tasks before public release include:

* Final code analysis
* End-to-end testing
* Firebase validation
* Production verification
* Play Store assets
* Privacy Policy publication

---

# Roadmap

### Version 1.0

* Authentication
* Building management
* Announcements
* Community chat
* Share & Help
* Push notifications
* Manager dashboard

### Future Versions

* iOS release
* AI-assisted translations
* Advanced moderation
* Community analytics
* Enhanced accessibility
* Additional notification preferences

---

# Contributing

At this stage, Joritna is under active development and is not accepting external contributions.

---

# License

Copyright © 2026 Joritna.

All rights reserved.

---

# Support

For questions, bug reports, or support:

**Email:** [support@joritna.com](mailto:support@joritna.com)

Website:

https://joritna.com

---

# Privacy

Privacy Policy

https://joritna.com/privacy

Terms of Use

https://joritna.com/terms

---

## About Joritna

Joritna is built to create safer, more connected residential communities by providing secure communication between tenants and building managers.

Our mission is to replace fragmented communication with one trusted platform that makes everyday residential life simpler, more organized, and more collaborative.
