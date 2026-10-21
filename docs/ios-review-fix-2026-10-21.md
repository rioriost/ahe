# iOS review correction — October 21, 2026

App: Anti-Homograph Extension, Apple ID 6824717064, version 0.1.0.
Source: c1f91a8 on main in rioriost/ahe. App implementation is unchanged from e6a5c98.

## Review finding and correction

Apple rejected iOS build 5 under Guideline 5.2.5 because the Japanese subtitle
used the Apple product name Safari inappropriately. The only localized App Store
language is Japanese. The shared App Information subtitle was changed and saved:

- Previous: Safariでドメイン名の類似文字を確認
- Corrected: ドメイン名の類似文字を確認

The review notes explain the correction. The description retains factual platform
compatibility and setup instructions. No application behavior was changed.
macOS 0.1.0 remains Waiting for Review in App Store Connect.

## Build and verification

A new iOS archive was built with CURRENT_PROJECT_VERSION=6. Host and extension are
0.1.0 (6), st.rio.ahe and st.rio.ahe.Extension, iPhone/iPad arm64, effective iOS17+.
Strict archive signature verification passed. Distribution export used Apple's
App Store signing and get-task-allow=false for both targets. Xcode reported upload
success at 14:11 JST. Local log: /tmp/ahe-ios-upload6.log.

Python 4 tests and Node 12 tests passed. Bundled extension resources match build5;
compiled Assets.car differs after rebuilding. The native UI and extension source
were unchanged. Previous simulator checks are documented in
[iOS validation](ios-validation-2026-10-20.md); they were not rerun as new runtime evidence.

## Coverage limits

- Physical iOS devices, minimum iOS17, VoiceOver, hardware keyboard, iPad multitasking,
  private browsing and separate profiles remain untested.
- On a fresh simulator, the settings shortcut may initially open Settings root;
  the app includes the full manual path.
- Existing iOS-on-Mac and Apple Vision Pro distribution options are enabled;
  those compatibility modes have not been tested. A separate native macOS submission
  is pending. App Store Connect compatibility eligibility is not runtime verification.

These are coverage warnings under Guidelines 2.1/2.4, not confirmed functionality failures.

## Submission preparation

Current settings checked: free, 175 storefronts, Utilities, age4+, no collected data,
privacy/support URLs, content rights, trader declaration, existing review contacts,
no login, retained iPhone/iPad screenshots and local demo attachment.
The release method was observed as automatic and restored to the user's previously
requested manual release. No pricing, territory, or compatibility options were changed.

Build 6 finished processing and was selected and saved in the iOS version.
Build ID: c692eee6-77cc-4d1a-b385-15cd23063b08. App Store Connect accepted Update Review and shows 0.1.0 (6) Ready for Review.
After action-time user confirmation, build 6 was resubmitted on October 21, 2026
at 14:51 JST. App Store Connect reports Waiting for Review for iOS 0.1.0 (6).
Submission ID: a92cfb55-2ef1-43bb-a2f7-440d8d762710.
https://appstoreconnect.apple.com/apps/6824717064/distribution/reviewsubmissions/details/a92cfb55-2ef1-43bb-a2f7-440d8d762710
Local evidence: build/appstore-ios/resubmitted-2026-10-21.png.
Release remains manual after approval. This receipt confirms submission, not approval.

## Official sources

- https://developer.apple.com/app-store/review/guidelines/#intellectual-property
- https://developer.apple.com/app-store/review/guidelines/#app-completeness
- https://developer.apple.com/app-store/review/guidelines/#hardware-compatibility
- https://developer.apple.com/help/app-store-connect/create-an-app-record/view-and-edit-app-information

Requirements retrieved October 21, 2026. Approval remains Apple's decision.
