local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-------------------------------------------------------------------------
-- 【1. 外観・デザインの設定】
-------------------------------------------------------------------------
config.window_background_opacity = 0.95
config.color_scheme = 'Kanagawa (Gogh)'
config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Yu Gothic UI",
})
config.font_size = 10.0
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.enable_scroll_bar = true
config.default_cursor_style = 'BlinkingUnderline'
config.use_ime = true
config.status_update_interval = 100
config.colors = {
  compose_cursor = '#E6C384',
}

-- ★ ウィンドウ周りに余白を作り、視認性を高める
config.window_padding = { left = 12, right = 12, top = 10, bottom = 10 }
-- ★ QuickSelectの文字をホームポジション優先にする
config.quick_select_alphabet = 'asdfghjklweruiop'

-------------------------------------------------------------------------
-- 【2. 右上ステータスバー：Leader状態可視化版】
-------------------------------------------------------------------------
wezterm.on('update-status', function(window, pane)
  local days = { "日", "月", "火", "水", "木", "金", "土" }
  local day_idx = tonumber(os.date("%w")) + 1
  local day_of_week = days[day_idx]
  local date = wezterm.strftime('%Y/%m/%d')
  local time = wezterm.strftime('%H:%M')
  local leader = ""
  if window:leader_is_active() then
    leader = '【LDR】 '
  end

  window:set_right_status(wezterm.format({
    {Foreground = {Color = '#E6C384'}},
    {Text = leader},
    {Foreground = {AnsiColor = 'Aqua'}},
    {Text = wezterm.nerdfonts.md_clock .. "  "},
    {Foreground = {AnsiColor = 'White'}},
    {Text = date .. "(" .. day_of_week .. ") " .. time .. " "},
  }))
end)

-------------------------------------------------------------------------
-- 【3. 基本システム設定】
-------------------------------------------------------------------------
config.default_prog = { 'powershell.exe', '-NoLogo' }
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-------------------------------------------------------------------------
-- 【4. キーバインド：Corne v4 ＆ Vim操作を極める】
-------------------------------------------------------------------------
config.leader = { key = 'x', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  { key = 'P', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette },
  { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.Search { CaseInSensitiveString = "" } },

  -- AI対策
  { key = 'Enter', mods = 'SHIFT', action = wezterm.action.SendString('\x1b[13;2u') },
  { key = 'Enter', mods = 'CTRL|SHIFT', action = wezterm.action.SendString('\x1b[13;2u') },

  -- [ペイン移動] Vimキーバインド (h, j, k, l)
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },

  -- ★ [ペインリサイズ] Leader + 大文字 H, J, K, L
  { key = 'H', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },

  -- ★ [ページ送り] Alt + j/k で高速スクロール（AI出力を追うのに便利）
  { key = 'j', mods = 'ALT', action = wezterm.action.ScrollByPage(0.5) },
  { key = 'k', mods = 'ALT', action = wezterm.action.ScrollByPage(-0.5) },

  -- [ペイン管理]
  { key = '2', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '3', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '0', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = '1', mods = 'LEADER', action = wezterm.action.TogglePaneZoomState },

  -- [タブ操作]
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },
  {
    key = 'r',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Rename Tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then window:active_tab():set_title(line) end
      end),
    },
  },

  -- [特殊操作]
  { key = 'f', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
  { key = 'Space', mods = 'LEADER', action = wezterm.action.QuickSelect },
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
}

-------------------------------------------------------------------------
-- 【5. 起動時に最大化】
-------------------------------------------------------------------------
wezterm.on('gui-startup', function(spawn_info)
  local _, _, window = wezterm.mux.spawn_window(spawn_info or {})
  window:gui_window():maximize()
end)

return config
