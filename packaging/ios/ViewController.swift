import UIKit
import SwiftUI
import SafariServices

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let host = UIHostingController(rootView: SetupView())
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
    }
}

private struct SetupView: View {
    @State private var settingsError = false
    private var japanese: Bool { Locale.preferredLanguages.first?.hasPrefix("ja") == true }
    private func text(_ ja: String, _ en: String) -> String { japanese ? ja : en }
    private var settingsPath: String {
        if #available(iOS 18, *) {
            return text("設定 ＞ アプリ ＞ Safari ＞ 機能拡張", "Settings > Apps > Safari > Extensions")
        }
        return text("設定 ＞ Safari ＞ 機能拡張", "Settings > Safari > Extensions")
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Image("LargeIcon").resizable().scaledToFit().frame(width: 64, height: 64).accessibilityHidden(true)
                        Text("Anti-Homograph Extension").font(.title.bold())
                        Text(text("英字に似たドメイン名の文字を、Safariで確認。", "Check domain characters that resemble English letters in Safari.")).font(.title3)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text(text("Safariで有効にする", "Enable in Safari")).font(.headline).accessibilityAddTraits(.isHeader)
                        step("1", text("「\(settingsPath)」を開きます。", "Open \(settingsPath)."))
                        step("2", text("Anti-Homograph Extensionを有効にします。", "Turn on Anti-Homograph Extension."))
                        step("3", text("Safariで確認したいWebサイトを開き、ページメニューからAHEへのアクセスを許可します。", "Open a website in Safari and use the page menu to allow AHE access to that website."))
                        if #available(iOS 26.2, *) {
                            Button(action: openSettings) {
                                Text(text("Safariの機能拡張設定を開く", "Open Safari Extension Settings"))
                                    .frame(maxWidth: .infinity).padding(.vertical, 4)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(text("ドメイン名を確認", "Inspect a domain")).font(.headline).accessibilityAddTraits(.isHeader)
                        Text(text("警告にはPunycode表記、Unicode表記、紛らわしい文字を表示します。SafariのページメニューからAHEを開くと、現在のドメイン名を個別に確認できます。", "Warnings show the Punycode name, Unicode name, and confusable characters. Open AHE from Safari’s page menu to inspect the current domain independently."))
                        Text(text("通信は遮断しません。警告が出る前にページが読み込まれる場合があります。警告がないことも、サイトの安全性を意味しません。", "Connections are not blocked. A page may load before a warning appears. The absence of a warning does not mean a site is safe.")).foregroundStyle(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        Label(text("判定は端末内で完結", "Checks stay on your device"), systemImage: "lock.shield").font(.headline).accessibilityAddTraits(.isHeader)
                        Text(text("閲覧履歴、個人情報、アクセス解析情報を保存・送信しません。アカウント登録や追加購入は不要です。", "No browsing history, personal data, or analytics is stored or sent. No account or additional purchase is required."))
                        Link(text("プライバシーポリシー", "Privacy policy"), destination: URL(string: "https://github.com/rioriost/ahe/blob/main/PRIVACY.md")!)
                            .padding(.vertical, 8)
                        Link(text("サポート", "Support"), destination: URL(string: "https://github.com/rioriost/ahe/issues")!)
                            .padding(.vertical, 8)
                    }
                }
                .frame(maxWidth: 640, alignment: .leading)
                .padding(24)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("AHE")
            .navigationBarTitleDisplayMode(.inline)
            .alert(text("設定を開けませんでした", "Couldn’t open Settings"), isPresented: $settingsError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(text("「\(settingsPath)」からAHEを有効にしてください。", "Enable AHE in \(settingsPath)."))
            }
        }
    }
    private func step(_ number: String, _ instruction: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number).font(.headline).foregroundStyle(.secondary).accessibilityHidden(true)
            Text(instruction).frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    private func openSettings() {
        if #available(iOS 26.2, *) {
            SFSafariSettings.openExtensionsSettings(forIdentifiers: ["st.rio.ahe.Extension"]) { error in
                if error != nil { settingsError = true }
            }
        }
    }
}
