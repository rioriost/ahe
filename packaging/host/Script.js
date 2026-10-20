const ja = navigator.language.startsWith('ja');
if (ja) {
 document.documentElement.lang = 'ja';
 const strings = {'intro':'英字に似たドメイン名の文字を検出して警告します。','state':'Safariの設定で機能拡張の状態を確認してください。','setup-title':'Webサイトへのアクセスを許可','setup':'「Safariの設定 ＞ 機能拡張」でAHEを有効にし、確認したいWebサイトへのアクセスを許可してください。ツールバーのポップアップから、現在のドメイン名も確認できます。','limit':'通信を遮断する機能ではなく、サイトの安全性を保証しません。警告が出る前にページが読み込まれる場合があります。','privacy-link':'プライバシーポリシー','support-link':'サポート','privacy':'判定は端末内で行います。閲覧履歴、アクセス解析情報、個人情報の保存や送信は行いません。'};
 for (const [id,value] of Object.entries(strings)) document.getElementById(id).textContent=value;
 document.querySelector('button').textContent='Safariの設定を開く…';
}
function show(enabled) {
 if(typeof enabled !== 'boolean') return;
 document.getElementById('state').textContent = ja ? (enabled ? '機能拡張は有効です。Webサイトへのアクセス許可も確認してください。' : '機能拡張は無効です。Safariの設定で有効にしてください。') : (enabled ? 'Extension enabled. Check website access permissions too.' : 'Extension disabled. Enable it in Safari Settings.');
}
document.querySelector('button').addEventListener('click',()=>webkit.messageHandlers.controller.postMessage('open-preferences'));
