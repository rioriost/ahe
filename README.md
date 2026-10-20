# Anti-Homograph Extension

[English](README.md) | [日本語](README-ja.md)

**AHE** is a standalone macOS Safari Web Extension that warns about non-ASCII
domain characters resembling ASCII letters. Code, artwork, and documentation
are MIT-licensed. Unicode data retains its separate Unicode license.

The policy originated in
[unbound-anti-homograph](https://github.com/rioriost/unbound-anti-homograph),
but this project does not include or require Unbound.

## What it detects

Each Punycode label is decoded and checked against 1,407 mappings from Unicode
17.0.0. A non-ASCII character mapped entirely to ASCII letters triggers a warning.
Single-script labels, subdomains, TLDs, and multi-letter mappings all count.
Malformed or non-canonical Punycode labels also trigger warnings.

| Domain | Result |
| --- | --- |
| `amazon.com` | No matching characters |
| `аmazon.com` (`xn--mazon-3ve.com`; Cyrillic U+0430) | Warning |
| `аррӏе.com` (`xn--80ak6aa92e.com`) | Warning |
| `bücher.de` / `日本語.jp` | No matching characters |

A banner shows the actual Punycode domain, Unicode display, and matching
characters. “Leave this page” replaces the page with `about:blank`.
Dismissing the banner lasts only for the current document; there is no allowlist.
The Safari toolbar popup independently checks the current address.
Japanese and English are supported, with light and dark appearance.

**This warns; it does not block connections or certify site safety.** Legitimate
names can trigger warnings. ASCII-only look-alikes and many other phishing
techniques are outside this policy.

## Install for development

The initial target is macOS Safari 27. Older Safari versions and iOS have not
been verified. This repository is source code, not an App Store listing or
a signed/notarized application release.

On Safari versions offering **Settings > Developer > Add Temporary Extension**,
select the repository's `extension` folder. Follow the unsigned-extension
authentication prompt, enable the extension, and grant website access.
Temporary extensions disappear when Safari quits or after 24 hours.

For automatic warnings, allow access to all websites or select the sites to
check. Installation alone does not grant access. The toolbar's `activeTab`
check does not establish that automatic warnings are enabled everywhere.
Review profile and private-browsing permissions separately.

To generate a macOS host app, install Xcode and run from the repository root:

```sh
sh scripts/package_safari.sh
python3 scripts/prepare_appstore.py
xcodebuild \
  -project 'build/safari/Anti-Homograph Extension/Anti-Homograph Extension.xcodeproj' \
  -scheme 'Anti-Homograph Extension' -configuration Debug \
  -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath build/safari-derived CODE_SIGNING_ALLOWED=NO build
```

On an Intel Mac, omit the `-destination` argument. Open the generated project
in Xcode and run its app to register the extension. Enable unsigned extensions
only as described in [Apple's development instructions](https://developer.apple.com/documentation/safariservices/running-your-safari-web-extension).
The scripts do not install the app or change Safari settings.

The packager refuses to overwrite an existing generated project. It references
the original extension resources: edits require rebuilding, while adding or
removing files requires regenerating the project. Use your own developer team
and appropriate bundle identifier for signed distribution.

## Distribution: GitHub is not the Safari extension catalog

To make the extension available through Safari's normal **Safari Extensions /
More Extensions** App Store entry point, enroll in the Apple Developer Program,
create an app record in App Store Connect, upload the extension's containing
app, and submit it for App Review and publication. Uploading alone does not
publish it. Apple's Safari Web Extension Packager in App Store Connect can also
package uploaded extension resources without Xcode.

For macOS distribution outside the Mac App Store, Apple supports a containing
app signed with a **Developer ID and notarized**. That app can be distributed
through GitHub Releases or a website without an App Store listing. Users install
the app and enable its extension in Safari; it is not discovered through the
App Store extension catalog. Publishing MIT source does not provide signing,
notarization, App Review, or App Store distribution.

Temporary unsigned loading is a development/testing route, not persistent
ordinary-user distribution. No App Store submission, signing, or notarization
has been performed for this repository.

## Privacy and limits

The extension makes no network requests and uses no telemetry, background
script, cookies, browsing-history storage, or saved exceptions. It classifies
the current hostname on-device. URL paths and query parameters are not shown
or stored. Unicode data ships in the extension.

A page may load and run scripts before a banner appears. A hostile website
can remove, cover, or imitate the banner despite its closed Shadow DOM.
Use the Safari toolbar popup for an extension-owned result. Links, frames,
subresources, CNAME targets, downloads, and other applications are not checked.
Restricted pages and sites without granted access cannot show automatic warnings.
Safari may reject or normalize a URL before the extension sees it; this is not
a full IDNA validator.

## Development

No npm dependencies are required. Use Python 3 and Node.js 22 or newer:

```sh
python3 scripts/build_safari_data.py --download
python3 scripts/build_safari_data.py --check
python3 -m unittest discover -s tests -v
node --test tests/safari.test.cjs
```

Downloading is a build-time action only. The official Unicode source commit and
SHA-256 are pinned in the generator, and downloaded data is cached in ignored
`build/confusables.txt`. Commit regenerated `extension/confusables.js` when
updating the Unicode version. CI verifies it against the pinned source.

On macOS, `swift tests/safari_webkit.swift` exercises real WebKit rendering,
focus, and dismissal with extension API stubs. It makes no test-site requests
and writes screenshots to `build/safari-webkit`; it does not register or enable
an extension in Safari. Regenerate original PNG artwork with
`swift scripts/build_safari_icons.swift`.

Before release, verify real Safari installation, website permissions, profiles,
private browsing, keyboard traversal, and VoiceOver. WebKit checks and unsigned
builds do not establish App Store readiness.

## License and primary sources

Original work is [MIT-licensed](LICENSE). Keep both `extension/LICENSE.txt` and
`extension/UNICODE-LICENSE.txt` in distributed extension resources; see [NOTICE](NOTICE).

Apple sources retrieved 2026-10-20:

| Source | Scope |
| --- | --- |
| [Distributing your Safari web extension](https://developer.apple.com/documentation/safariservices/distributing-your-safari-web-extension) | App Store publication; Developer ID and notarized macOS distribution |
| [Packaging with App Store Connect](https://developer.apple.com/documentation/safariservices/packaging-and-distributing-safari-web-extensions-with-app-store-connect) | Web-based packaging, TestFlight, review and publication |
| [Get extensions in Safari](https://support.apple.com/guide/safari/get-extensions-sfri32508/mac) | Safari's ordinary App Store installation route |
| [Running your Safari web extension](https://developer.apple.com/documentation/safariservices/running-your-safari-web-extension) | Temporary loading, unsigned development, and activation |
| [Packaging a web extension for Safari](https://developer.apple.com/documentation/safariservices/packaging-a-web-extension-for-safari) | Xcode packager, formerly named converter |
| [Alerts](https://developer.apple.com/design/human-interface-guidelines/alerts) / [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility) | Clear warning text, meaningful actions, and accessible presentation |

The UI is semantic Web content, not a native macOS alert. Automatic warnings
do not intentionally move focus or show modal dialogs. Text, not color alone,
conveys the warning; there is no animation or external font dependency.
