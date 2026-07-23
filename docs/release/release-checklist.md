# Joritna Mobile Release Checklist

This document defines the final release checklist before publishing Joritna Mobile to the Google Play Store.

---

# Release Information

| Item | Value |
|------|-------|
| Product | Joritna Mobile |
| Version | 1.0.0 |
| Release Type | MVP |
| Platform | Android |
| Status | Release Hardening |

---

# Phase 1 — Code Quality

## Static Analysis

- [ ] `flutter analyze` returns **0 errors**
- [ ] `flutter analyze` returns **0 warnings**
- [ ] `dart format .` completed
- [ ] Remove unused imports
- [ ] Remove dead code
- [ ] Remove obsolete TODO comments
- [ ] Remove debug print statements
- [ ] Verify lint rules pass

---

# Phase 2 — Functional Testing

## Authentication

- [ ] Login
- [ ] Logout
- [ ] Auto login
- [ ] Session restoration
- [ ] Invalid credentials
- [ ] Expired JWT handling

---

## Tenant

- [ ] Join building
- [ ] Leave building
- [ ] Dashboard loads correctly
- [ ] View building information
- [ ] View announcements
- [ ] Community chat
- [ ] Share & Help
- [ ] Upload image
- [ ] Profile update
- [ ] Change password

---

## Manager

- [ ] Create building
- [ ] Update building
- [ ] View building details
- [ ] View tenants
- [ ] Remove tenant
- [ ] Publish announcements
- [ ] Settings
- [ ] Profile update
- [ ] Change password

---

# Phase 3 — Notifications

## Firebase Cloud Messaging

- [ ] Device registration
- [ ] Foreground notification
- [ ] Background notification
- [ ] Terminated notification
- [ ] Notification tap navigation
- [ ] Token refresh
- [ ] Multiple device support
- [ ] Android notification permission

---

# Phase 4 — Backend Integration

## API

- [ ] Production API reachable
- [ ] HTTPS working
- [ ] JWT authentication
- [ ] Refresh token flow
- [ ] Error handling
- [ ] Offline handling

---

## Media

- [ ] Avatar upload
- [ ] Avatar display
- [ ] Image upload
- [ ] Image download

---

## Realtime

- [ ] WebSocket connection
- [ ] Automatic reconnect
- [ ] Chat updates
- [ ] Notification updates

---

# Phase 5 — UI Review

## General

- [ ] No overflow errors
- [ ] Responsive layouts
- [ ] Consistent spacing
- [ ] Consistent colors
- [ ] Consistent typography
- [ ] Proper loading indicators
- [ ] Proper empty states
- [ ] Proper error states

---

## Accessibility

- [ ] Buttons are tappable
- [ ] Icons are clear
- [ ] Text is readable
- [ ] Navigation is intuitive

---

# Phase 6 — Performance

- [ ] Smooth scrolling
- [ ] Fast startup
- [ ] Image caching verified
- [ ] No unnecessary rebuilds
- [ ] Controllers disposed correctly
- [ ] Memory usage verified

---

# Phase 7 — Security

- [ ] HTTPS only
- [ ] No hardcoded secrets
- [ ] Firebase configuration verified
- [ ] Secure token storage
- [ ] Release mode enabled
- [ ] Debug logs removed

---

# Phase 8 — Play Store Preparation

## Branding

- [ ] Production app icon
- [ ] Adaptive Android icon
- [ ] Splash screen
- [ ] App name verified

---

## Documentation

- [ ] README updated
- [ ] CHANGELOG.md created
- [ ] Privacy Policy published
- [ ] Terms of Use published

---

## Store Assets

- [ ] Feature graphic (1024×500)
- [ ] App icon (512×512)
- [ ] Phone screenshots
- [ ] Short description
- [ ] Full description

---

## Contact

- [ ] Support email
- [ ] Privacy email (optional)
- [ ] Website URL

---

# Phase 9 — Android Release

## Signing

- [ ] Release keystore created
- [ ] Signing configuration verified
- [ ] Version name updated
- [ ] Version code updated

---

## Build

- [ ] Release APK generated
- [ ] Release AAB generated
- [ ] Installation tested
- [ ] Startup verified

Build commands:

```bash
flutter build apk --release
```

```bash
flutter build appbundle --release
```

---

# Phase 10 — Closed Testing

- [ ] Upload AAB to Google Play Console
- [ ] Create Closed Testing track
- [ ] Invite internal testers
- [ ] Collect feedback
- [ ] Fix release-blocking issues
- [ ] Verify crash reports
- [ ] Verify Firebase Analytics (if enabled)

---

# MVP Acceptance Criteria

The application is ready for public release when:

- [ ] No critical bugs remain
- [ ] No application crashes
- [ ] Firebase notifications work reliably
- [ ] Tenant workflows are fully functional
- [ ] Manager workflows are fully functional
- [ ] Production backend is stable
- [ ] Play Store assets are complete
- [ ] Privacy Policy is publicly available
- [ ] Terms of Use are publicly available
- [ ] README is up to date
- [ ] CHANGELOG is complete

---

# Final Approval

| Item | Status |
|------|--------|
| Development | ☐ |
| Testing | ☐ |
| Documentation | ☐ |
| Store Assets | ☐ |
| Release Build | ☐ |
| Play Store Upload | ☐ |

---

# Release Tag

```
v1.0.0
```

---

# Notes

This checklist must be completed before publishing **Joritna Mobile v1.0.0** to the Google Play Store.

The goal of this release is to deliver a stable, secure, and production-ready MVP that provides a high-quality experience for both tenants and building managers.