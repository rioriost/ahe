# iOS/iPadOS validation — October 20, 2026

Target: AHE 0.1.0 (5), iOS/iPadOS 17+, iPhone and iPad. Host st.rio.ahe;
extension st.rio.ahe.Extension. Xcode 27.1 SDK, iOS 27 simulator runtime.
The separate generated iOS project preserves the existing macOS archive and submission.

## Confirmed

- Native Japanese setup on iPhone 17 Pro, iPhone 17 Pro Max and iPad Pro 13-inch M4 simulators.
- Safari site permission, automatic warning, and independent popup on iPhone/iPad,
  using only a local test hostname. Dismiss/reload checked on iPhone.
- iPhone pages without a mobile viewport retain legible warning text; zoom-out is
  compensated without overriding user zoom-in or modifying the page viewport.
- iPhone sheet fills available width; iPad intrinsic popover no longer collapses.
- Native setup: iPhone landscape, dark appearance and largest simulator Text Size
  setting (11); text wraps and the scroll view reaches privacy/support links.
- Native accessibility labels/headings inspected. This is not a VoiceOver result.
- Python: 4 tests; Node: 12 tests; desktop WebKit harness: 7 scenarios, including
  focus/dismissal, dark appearance and 200% zoom. WebKit uses extension API stubs.
- Unicode 17.0.0 data integrity check, archive build, strict signature validation,
  App Store upload and processing successful. Build 5 selected in the iOS version.
- Actual iPhone/iPad screenshots and iOS-specific review demo/notes registered;
  App Store Connect accepted Add for Review with no required-field error.

## Remaining coverage

Physical iOS devices, iOS/iPadOS 17, VoiceOver, hardware keyboard traversal,
iPad multitasking widths, private browsing and separate Safari profiles were not
tested. These are coverage gaps, not confirmed passing behavior.

On a fresh simulator, Apple's Safari extension-settings shortcut initially opened
the Settings root. The host also displays the manual navigation path. No private
Settings URL schemes or permission bypasses are used.

The extension warns; it does not block traffic or guarantee safety. No data
collection, history storage, backend, accounts, tracking or third-party SDKs were added.
App Review submission and approval are separate from the technical checks above.

## Primary sources checked

- https://developer.apple.com/help/app-store-connect/create-an-app-record/add-platforms/
- https://developer.apple.com/design/human-interface-guidelines/designing-for-ios
- https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados
- https://developer.apple.com/design/human-interface-guidelines/accessibility
- https://developer.apple.com/documentation/safariservices/sfsafarisettings
- https://developer.apple.com/app-store/review/guidelines/

HIG is design guidance. Availability of the settings shortcut is guarded using the
SDK's iOS 26.2 availability declaration. Review requirements were checked separately.
