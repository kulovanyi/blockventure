extends Control

signal restart_requested
signal lobby_requested

@onready var title_lbl: Label = $Panel/VBoxContainer/Title
@onready var reason_lbl: Label = $Panel/VBoxContainer/Reason
@onready var score_lbl: Label = $Panel/VBoxContainer/ScoreCard/ScoreVal
@onready var best_lbl: Label = $Panel/VBoxContainer/ScoreCard/BestVal

func _ready() -> void:
	$Panel/VBoxContainer/Buttons/BtnRestart.pressed.connect(func():
		visible = false
		SoundManager.play_click()
		emit_signal("restart_requested")
	)
	$Panel/VBoxContainer/Buttons/BtnLobby.pressed.connect(func():
		visible = false
		SoundManager.play_click()
		emit_signal("lobby_requested")
	)

func show_modal(reason: String) -> void:
	reason_lbl.text = reason
	score_lbl.text = str(GameManager.score)
	var best = SaveManager.profile.get("adventureBest" if GameManager.game_mode == "adventure" else "classicBest", 0)
	best_lbl.text = str(best)
	visible = true
	SoundManager.play_explosion()
