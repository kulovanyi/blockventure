extends Control

# Header nodes
@onready var lbl_player_name: Label = $VBoxContainer/TopHeader/PlayerInfo/Name
@onready var lbl_avatar: Label = $VBoxContainer/TopHeader/PlayerInfo/Avatar
@onready var lbl_coins: Label = $VBoxContainer/TopHeader/CoinsBadge/HBox/CoinCount
@onready var btn_top_codex: Button = $VBoxContainer/TopHeader/BtnCodex
@onready var btn_top_settings: Button = $VBoxContainer/TopHeader/BtnSettings

# Screen views
@onready var screen_lobby: Control = $VBoxContainer/ScreenContainer/LobbyScreen
@onready var screen_game: Control = $VBoxContainer/ScreenContainer/GameScreen
@onready var screen_shop: Control = $VBoxContainer/ScreenContainer/ShopScreen
@onready var screen_upgrades: Control = $VBoxContainer/ScreenContainer/UpgradesScreen
@onready var screen_codex: Control = $VBoxContainer/ScreenContainer/CodexScreen
@onready var screen_achievements: Control = $VBoxContainer/ScreenContainer/AchievementsScreen
@onready var screen_leaderboard: Control = $VBoxContainer/ScreenContainer/LeaderboardScreen

# Bottom Nav
@onready var nav_lobby: Button = $VBoxContainer/BottomNav/BtnLobby
@onready var nav_shop: Button = $VBoxContainer/BottomNav/BtnShop
@onready var nav_upgrades: Button = $VBoxContainer/BottomNav/BtnUpgrades
@onready var nav_codex: Button = $VBoxContainer/BottomNav/BtnCodex
@onready var nav_achievements: Button = $VBoxContainer/BottomNav/BtnAch
@onready var nav_leaderboard: Button = $VBoxContainer/BottomNav/BtnLeaderboard

# Modals
@onready var game_over_modal: Control = $GameOverModal
@onready var settings_modal: Control = $SettingsModal

func _ready() -> void:
	SaveManager.profile_updated.connect(update_header)
	SaveManager.coins_changed.connect(func(c): lbl_coins.text = str(c))
	GameManager.game_over_triggered.connect(_on_game_over)
	
	screen_lobby.start_mode_selected.connect(_on_start_mode)
	
	game_over_modal.restart_requested.connect(func():
		screen_game.start_game(GameManager.game_mode)
	)
	game_over_modal.lobby_requested.connect(func():
		switch_screen("lobby")
	)
	settings_modal.exit_game_requested.connect(func():
		switch_screen("lobby")
	)
	
	btn_top_codex.pressed.connect(func(): switch_screen("codex"))
	btn_top_settings.pressed.connect(func(): settings_modal.open())
	
	nav_lobby.pressed.connect(func(): switch_screen("lobby"))
	nav_shop.pressed.connect(func(): switch_screen("shop"))
	nav_upgrades.pressed.connect(func(): switch_screen("upgrades"))
	nav_codex.pressed.connect(func(): switch_screen("codex"))
	nav_achievements.pressed.connect(func(): switch_screen("achievements"))
	nav_leaderboard.pressed.connect(func(): switch_screen("leaderboard"))
	
	game_over_modal.visible = false
	settings_modal.visible = false
	
	update_header()
	switch_screen("lobby")

func update_header() -> void:
	lbl_player_name.text = SaveManager.profile.get("playerName", "Játékos")
	lbl_avatar.text = SaveManager.profile.get("avatarIcon", "🧑‍🚀")
	lbl_coins.text = str(SaveManager.get_coins())

func switch_screen(screen_name: String) -> void:
	SoundManager.play_click()
	
	screen_lobby.visible = (screen_name == "lobby")
	screen_game.visible = (screen_name == "game")
	screen_shop.visible = (screen_name == "shop")
	screen_upgrades.visible = (screen_name == "upgrades")
	screen_codex.visible = (screen_name == "codex")
	screen_achievements.visible = (screen_name == "achievements")
	screen_leaderboard.visible = (screen_name == "leaderboard")

func _on_start_mode(mode: String) -> void:
	switch_screen("game")
	screen_game.start_game(mode)

func _on_game_over(reason: String) -> void:
	game_over_modal.show_modal(reason)
