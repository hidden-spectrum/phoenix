# Phoenix

A Swift analytics abstraction library that provides a unified interface for multiple analytics providers.

## Overview

Phoenix abstracts away the complexity of working with different analytics SDKs by providing a single, type-safe API. While originally built around Firebase Analytics, Phoenix currently supports [PostHog](https://posthog.com) with additional providers planned for the future.

## Features

- **Unified API** - Single interface for all analytics operations
- **Type Safety** - Strongly-typed events, parameters, and screens
- **SwiftUI Integration** - Environment values and view modifiers for seamless tracking
- **Feature Flags** - A/B testing and feature flag support with type-safe variants
- **Commerce Tracking** - Built-in StoreKit transaction logging
- **Crash Reporting** - MetricKit integration for crash diagnostics

## Requirements

- iOS 16.0+ / macOS 13.0+ / tvOS 16.0+
- Swift 6.0+

## Installation

Add Phoenix to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/hidden-spectrum/phoenix.git", from: "1.0.0")
]
```

Then add the targets you need:

```swift
.target(
    name: "YourApp",
    dependencies: [
        "Phoenix",      // Core library (required)
        "PhoenixPH",    // PostHog provider
    ]
)
```

## Quick Start

### 1. Create your analytics instance

```swift
import Phoenix
import PhoenixPH
import PostHog

// Configure PostHog
let config = PostHogConfig(apiKey: "your-api-key")
config.host = "https://app.posthog.com"

// Create Phoenix instance
let phoenix = Phoenix(provider: PostHogAnalyticsProvider(with: config))
```

### 2. Initialize on app launch

```swift
@main
struct MyApp: App {
    init() {
        phoenix.appDidFinishLaunching()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.phoenix, phoenix)
        }
    }
}
```

### 3. Track events

```swift
struct ContentView: View {
    @Environment(\.phoenix) private var phoenix

    var body: some View {
        Button("Purchase") {
            phoenix.logEvent(.purchaseTapped)
        }
    }
}
```

## Defining Your Analytics

Phoenix uses type-safe structs that you extend with static constants. This provides autocomplete, compile-time safety, and a centralized place to define your analytics taxonomy.

### Events

```swift
extension AnalyticsEvent {
    // Authentication
    static let loginTapped = Event("login_tapped")
    static let signupCompleted = Event("signup_completed")
    static let logoutTapped = Event("logout_tapped")

    // Navigation
    static let tabSelected = Event("tab_selected")
    static let backTapped = Event("back_tapped")

    // Content
    static let itemViewed = Event("item_viewed")
    static let itemShared = Event("item_shared")

    // Events with default parameters
    static func searchPerformed(query: String) -> Event {
        Event("search_performed", parameters: [
            .searchTerm: query
        ])
    }

    static func itemAddedToCart(itemId: String, price: Double) -> Event {
        Event("item_added_to_cart", parameters: [
            .contentId: itemId,
            .price: price
        ])
    }
}
```

### Screens

```swift
extension AnalyticsScreen {
    static let home = Screen("home")
    static let search = Screen("search")
    static let profile = Screen("profile")
    static let settings = Screen("settings")
    static let onboarding = Screen("onboarding")
    static let checkout = Screen("checkout")
    static let productDetail = Screen("product_detail")
}
```

### Parameters

```swift
extension AnalyticsParameter {
    static let itemCategory = Parameter("item_category")
    static let subscriptionTier = Parameter("subscription_tier")
    static let referralSource = Parameter("referral_source")
    static let experimentGroup = Parameter("experiment_group")
}
```

### Element Names

```swift
extension AnalyticsElementName {
    static let submitButton: ElementName = "submit_button"
    static let cancelButton: ElementName = "cancel_button"
    static let shareButton: ElementName = "share_button"
    static let productCell: ElementName = "product_cell"
    static let settingsRow: ElementName = "settings_row"
}
```

### Feature Flags

```swift
extension AnalyticsFeatureFlag {
    static let newCheckoutFlow = Feature("new_checkout_flow")
    static let darkModeEnabled = Feature("dark_mode_enabled")
    static let premiumFeatures = Feature("premium_features")
}
```

### Experiments

```swift
enum OnboardingVariant: String, AnalyticsExperimentVariant {
    case control
    case shortFlow = "short_flow"
    case videoIntro = "video_intro"
}

extension AnalyticsExperiment where Variant == OnboardingVariant {
    static let onboarding = AnalyticsExperiment(
        "onboarding_experiment",
        variantType: OnboardingVariant.self
    )
}
```

## Usage

### Logging Events

```swift
// Simple event
phoenix.logEvent(.loginTapped)

// Event with screen context
phoenix.logEvent(.itemViewed, on: .productDetail)

// Event with additional parameters
phoenix.logEvent(
    .searchPerformed(query: "swift"),
    additionalParameters: [
        .success: true,
        .itemCategory: "books"
    ]
)
```

### Screen Views

```swift
phoenix.logScreenView(.productDetail, parameters: [
    .contentId: "product-123"
])
```

### User Properties

```swift
// Set user ID
phoenix.setUserId("user-12345")

// Set individual property
phoenix.setUserProperty(.subscriptionTier, to: "premium")

// Set multiple properties
phoenix.setUserProperties([
    .subscriptionTier: "premium",
    .referralSource: "friend"
])
```

### Global Properties

Properties attached to all subsequent events:

```swift
// Register global properties
phoenix.registerGlobalProperties([
    .experimentGroup: "A",
    .subscriptionTier: "free"
])

// Remove a global property
phoenix.unregisterGlobalProperty(.experimentGroup)
```

### Element Tracking

Track UI element interactions:

```swift
// Track button click
phoenix.logElementClick(
    name: .submitButton,
    type: .button,
    on: .checkout
)

// Track with value
phoenix.logElementClick(
    name: "quantity_stepper",
    type: .number,
    value: 5,
    on: .productDetail
)
```

### Flushing Events

Force pending events to be sent immediately:

```swift
// Flush before app goes to background
phoenix.flush()
```

## SwiftUI Integration

### Environment Values

Phoenix provides SwiftUI environment integration:

```swift
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.phoenix, phoenix)
                .environment(\.analyticsScreen, .home)
        }
    }
}
```

### View Modifiers

Track clicks with view modifiers:

```swift
Button("Add to Cart") {
    addToCart()
}
.analyticsClick(
    name: "add_to_cart",
    type: .button,
    screen: .productDetail
)
```

### Screen Tracking (PostHog)

Automatically track screen views:

```swift
NavigationStack {
    ProductListView()
        .analyticsScreen(.productDetail)
}
```

### AnalyticsTrackingButton

A drop-in `Button` replacement with built-in analytics. Prefer this over `.analyticsClick()` which can sometimes override tap behavior on certain views.

```swift
// Simple usage
AnalyticsTrackingButton(name: "submit") {
    submitForm()
} label: {
    Text("Submit")
}

// With custom type and parameters
AnalyticsTrackingButton(
    name: "add_to_cart",
    type: .button,
    parameters: [
        .contentId: product.id,
        .price: product.price
    ]
) {
    addToCart(product)
} label: {
    Label("Add to Cart", systemImage: "cart.badge.plus")
}
```

### Presentation Context

Track modal presentations with context:

```swift
.sheet(isPresented: $showDetail) {
    DetailView()
        .analyticsPresentationContext(
            elementName: .productCell,
            elementType: .cell,
            screen: .search
        )
}
```

## Feature Flags & A/B Testing

### Feature Flags

```swift
if phoenix.featureEnabled(.newCheckoutFlow) {
    showNewCheckout()
} else {
    showLegacyCheckout()
}
```

### A/B Testing with Variants

```swift
switch phoenix.enabledVariant(for: .onboarding) {
case .control:
    showStandardOnboarding()
case .shortFlow:
    showShortOnboarding()
case .videoIntro:
    showVideoOnboarding()
case nil:
    showStandardOnboarding() // Default fallback
}
```

### Reload Feature Flags

```swift
Task {
    await phoenix.reloadFeatureFlags()
    updateUI()
}
```

## Commerce & StoreKit

### Transaction Logging

```swift
// Log StoreKit transaction
phoenix.logTransaction(transaction)
```

## Error & Crash Reporting

### Error Logging

```swift
do {
    try riskyOperation()
} catch {
    phoenix.logError(
        error,
        on: .settings,
        additionalParameters: [.init("operation"): "data_sync"]
    )
}
```

### MetricKit Crash Diagnostics

```swift
class MetricsHandler: MXMetricManagerSubscriber {
    func didReceive(_ payloads: [MXDiagnosticPayload]) {
        for payload in payloads {
            if let crashDiagnostics = payload.crashDiagnostics {
                for crash in crashDiagnostics {
                    phoenix.logCrash(crash)
                }
            }
        }
    }
}
```

## License

MIT License. See [LICENSE](LICENSE) for details.
