#!/usr/bin/env python3
"""Apply reproducible release metadata to the generated Xcode project."""
from pathlib import Path
import json, plistlib, shutil
root = Path(__file__).resolve().parent.parent
name = 'Anti-Homograph Extension'
project = root / 'build/safari' / name
pbx = project / f'{name}.xcodeproj/project.pbxproj'
s = pbx.read_text().replace('io.github.rioriost.Anti-Homograph-Extension', 'st.rio.ahe')
s = s.replace('MARKETING_VERSION = 1.0;', 'MARKETING_VERSION = 0.1.0;')
pbx.write_text(s)
host = project / name
p = host / 'Info.plist'
d = plistlib.loads(p.read_bytes()); d.update(LSApplicationCategoryType='public.app-category.utilities', ITSAppUsesNonExemptEncryption=False, NSHumanReadableCopyright='Copyright © 2026 Ryo Fujita')
p.write_bytes(plistlib.dumps(d))
for n in ['Style.css', 'Script.js']:
 shutil.copyfile(root / 'packaging/host' / n, host / 'Resources' / n)
shutil.copyfile(root / 'packaging/host/Main.html', host / 'Resources/Base.lproj/Main.html')
p = host / 'Base.lproj/Main.storyboard'
p.write_text(p.read_text().replace('width="425" height="325"','width="600" height="650"'))
p = host / 'ViewController.swift'
s = p.read_text().replace('io.github.rioriost.Anti-Homograph-Extension', 'st.rio.ahe')
s = s.replace('if (message.body as! String != "open-preferences") {','if (message.body as? String != "open-preferences") {')
s = s.replace('NSApplication.shared.terminate(nil)', 'if let error {\n                    let alert = NSAlert(error: error)\n                    alert.runModal()\n                }')
start = s.find('\n    func webView(_ webView: WKWebView, decidePolicyFor')
if start != -1:
    s = s[:start] + '\n}\n'
pos=s.rfind('\n}')
s=s[:pos]+'''
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, ["https", "http"].contains(url.scheme ?? "") {
            NSWorkspace.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
'''+s[pos:]
p.write_text(s)
# No native messaging is used; avoid retaining the converter's sample message logging.
p = project / f'{name} Extension/SafariWebExtensionHandler.swift'
p.write_text('import SafariServices\nclass SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {\n    func beginRequest(with context: NSExtensionContext) {\n        context.completeRequest(returningItems: [], completionHandler: nil)\n    }\n}\n')
print('Prepared st.rio.ahe version 0.1.0, Utilities category, local host UI and privacy links')
