#!/usr/bin/env python3
"""Apply the iOS host and release metadata to Apple's generated project."""
from pathlib import Path
import plistlib
import shutil
import re

root = Path(__file__).resolve().parent.parent
name = 'Anti-Homograph Extension'
project = root / 'build/safari-ios' / name
host = project / name
pbx = project / f'{name}.xcodeproj/project.pbxproj'
s = pbx.read_text()
s = s.replace('MARKETING_VERSION = 1.0;', 'MARKETING_VERSION = 0.1.0;')
s = s.replace('PRODUCT_BUNDLE_IDENTIFIER = "st.rio.Anti-Homograph-Extension";', 'PRODUCT_BUNDLE_IDENTIFIER = st.rio.ahe;')
pbx.write_text(s)
p = host / 'Info.plist'
d = plistlib.loads(p.read_bytes())
d.update(ITSAppUsesNonExemptEncryption=False, CFBundleLocalizations=['en', 'ja'])
p.write_bytes(plistlib.dumps(d))
shutil.copyfile(root / 'packaging/ios/ViewController.swift', host / 'ViewController.swift')
p = host / 'Base.lproj/Main.storyboard'
s = p.read_text()
s = re.sub(r'\s*<subviews>.*?</subviews>', '', s, flags=re.S)
s = re.sub(r'\s*<connections>.*?</connections>', '', s, flags=re.S)
p.write_text(s)
p = project / f'{name} Extension/SafariWebExtensionHandler.swift'
p.write_text('import SafariServices\nclass SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {\n    func beginRequest(with context: NSExtensionContext) {\n        context.completeRequest(returningItems: [], completionHandler: nil)\n    }\n}\n')
print('Prepared iPhone/iPad app st.rio.ahe version 0.1.0 with native setup and privacy information')
