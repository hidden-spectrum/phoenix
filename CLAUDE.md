# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build
```bash
swift build
```

### Test
```bash
# Run all tests
swift test

# Run tests for a specific target
swift test --target PhoenixTests
swift test --target PhoenixFirebaseTests

# Run a specific test with filter
swift test --filter "AnalyticsParametersTests"
```

### Clean
```bash
swift package clean
```

### Update Dependencies
```bash
swift package update
```

### Generate Xcode Project (if needed)
```bash
swift package generate-xcodeproj
```

## Architecture

Phoenix is a Swift analytics abstraction library that provides a unified interface for multiple analytics providers (PostHog, Firebase, etc.).

### Core Components

1. **Phoenix** (Sources/Phoenix/Bootstrap/Phoenix.swift:9-119)
   - Main entry point for the library
   - Wraps an `AnalyticsProvider` instance
   - Provides convenience methods for logging events, screen views, and user properties
   - Thread-safe with `nonisolated(unsafe)` provider storage

2. **AnalyticsProvider Protocol** (Sources/Phoenix/Protocols/AnalyticsProvider.swift:9-28)
   - Defines the interface all analytics providers must implement
   - Methods for setup, user management, event logging, and transactions

3. **Key Models**
   - `AnalyticsEvent`: Represents trackable events with parameters
   - `AnalyticsScreen`: Represents screen/view contexts
   - `AnalyticsParameters`: Type-safe parameter dictionary
   - `AnalyticsParameter`: Strongly-typed parameter keys
   - `AnalyticsElement`: Protocol for UI elements that can be tracked

### Provider Implementations

1. **PhoenixPH** - PostHog integration
   - `PostHogAnalyticsProvider` implements the `AnalyticsProvider` protocol
   - Maps Phoenix types to PostHog SDK types
   - Handles user identification and property management

2. **PhoenixFB** - Firebase Analytics integration (structure present but implementation not shown)

3. **Testing Support**
   - `StubAnalyticsProvider`: No-op implementation for production code that doesn't need analytics
   - `TestingAnalyticsProvider`: Captures events for verification in tests

### Design Patterns

- **Protocol-Oriented**: Core functionality defined through protocols
- **Type Safety**: Strong typing for parameters, events, and screens
- **Modular**: Separate targets for each analytics provider
- **Testable**: Built-in testing support with dedicated providers

### Testing

The project uses Swift Testing framework (not XCTest) as evidenced by `@Suite` and `@Test` attributes. Tests are organized by component within the Tests directory.