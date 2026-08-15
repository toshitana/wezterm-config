# WezTerm config

Windows向けの個人用WezTerm設定です。

## 主な設定

- Kanagawa配色とJetBrains Mono / Yu Gothic UI
- PowerShellをデフォルトシェルとして起動
- Vim風のペイン移動・リサイズ
- Leaderキー（`Ctrl+x`）を使ったペイン・タブ操作
- 日時とLeader状態を表示するステータスバー
- 起動時にウィンドウを最大化

## インストール

`.wezterm.lua` をユーザーホームに配置します。

```powershell
Copy-Item .wezterm.lua $HOME\.wezterm.lua
```

WezTermで設定を再読み込みすると反映されます。
