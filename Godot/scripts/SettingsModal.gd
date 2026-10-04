extends Control

signal exit_game_requested

@onready var slider_volume: HSlider = $Panel/VBoxContainer/VolRow/HSlider
@onready var check_sound: CheckButton = $Panel/VBoxContainer/SoundRow/CheckButton

func _ready() -> void:
	$Panel/VBoxContainer/BtnClose.pressed.connect(func():
		visible = false
		SoundManager.play_click()
	)
	$Panel/VBoxContainer/BtnExitGame.pressed.connect(func():
		visible = false
		SoundManager.play_click()
		emit_signal("exit_game_requested")
	)
	
	slider_volume.value_changed.connect(func(val):
		SoundManager.set_volume(val)
	)
	
	check_sound.toggled.connect(func(toggled):
		SoundManager.set_muted(not toggled)
	)

func open() -> void:
	slider_volume.value = SoundManager.volume
	check_sound.button_pressed = not SoundManager.muted
	visible = true
