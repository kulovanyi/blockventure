extends Control

signal start_mode_selected(mode: String)

@onready var classic_best_label: Label = $ScrollContainer/VBoxContainer/ModeCards/ClassicCard/HBox/Info/BestLabel
@onready var adventure_best_label: Label = $ScrollContainer/VBoxContainer/ModeCards/AdventureCard/HBox/Info/BestLabel
@onready var daily_btn: Button = $ScrollContainer/VBoxContainer/DailyRewardCard/HBox/BtnClaim

func _ready() -> void:
	$ScrollContainer/VBoxContainer/ModeCards/ClassicCard/HBox/BtnPlay.pressed.connect(func():
		SoundManager.play_click()
		emit_signal("start_mode_selected", "classic")
	)
	$ScrollContainer/VBoxContainer/ModeCards/AdventureCard/HBox/BtnPlay.pressed.connect(func():
		SoundManager.play_click()
		emit_signal("start_mode_selected", "adventure")
	)
	daily_btn.pressed.connect(_on_claim_daily)
	SaveManager.profile_updated.connect(refresh_ui)
	refresh_ui()

func refresh_ui() -> void:
	classic_best_label.text = "Rekord: %s" % str(SaveManager.profile.get("classicBest", 0))
	adventure_best_label.text = "Rekord: %s" % str(SaveManager.profile.get("adventureBest", 0))
	
	var today = Time.get_date_string_from_system()
	if SaveManager.profile.get("lastDailyClaim", "") == today:
		daily_btn.disabled = true
		daily_btn.text = "Már átvéve ✓"
	else:
		daily_btn.disabled = false
		daily_btn.text = "Átvétel 🎁"

func _on_claim_daily() -> void:
	var today = Time.get_date_string_from_system()
	SaveManager.profile["lastDailyClaim"] = today
	SaveManager.add_coins(100)
	SoundManager.play_coin()
	refresh_ui()
