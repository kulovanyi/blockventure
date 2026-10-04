extends Control

signal cell_clicked(r: int, c: int)
signal cell_hovered(r: int, c: int)

var row: int = 0
var col: int = 0
var is_filled: bool = false
var color_name: String = ""
var has_coin: bool = false

@onready var bg_rect: ColorRect = $BgRect
@onready var coin_icon: Label = $CoinIcon

func _ready() -> void:
	custom_minimum_size = Vector2(54, 54)
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	update_visual()

func init_cell(r: int, c: int) -> void:
	row = r
	col = c

func set_filled(col_name: String, with_coin: bool = false) -> void:
	is_filled = true
	color_name = col_name
	has_coin = with_coin
	update_visual()

func clear_cell() -> void:
	is_filled = false
	color_name = ""
	has_coin = false
	update_visual()

func update_visual() -> void:
	if not is_inside_tree(): return
	if is_filled:
		var c = GameManager.COLOR_MAP.get(color_name, Color(0.2, 0.4, 0.8))
		bg_rect.color = c
		bg_rect.modulate = Color(1.1, 1.1, 1.1, 1.0)
	else:
		bg_rect.color = Color(1.0, 1.0, 1.0, 0.05)
		bg_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	coin_icon.visible = has_coin

func set_preview(is_preview: bool) -> void:
	if is_filled: return
	if is_preview:
		bg_rect.color = Color(1.0, 1.0, 1.0, 0.25)
	else:
		update_visual()

func set_will_clear(will_clear: bool) -> void:
	if will_clear:
		var tween = create_tween()
		tween.tween_property(bg_rect, "modulate", Color(2.0, 2.0, 1.5, 1.0), 0.15)
	else:
		bg_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)

func set_targeting_hover(is_target: bool) -> void:
	if is_target:
		bg_rect.color = Color(0.94, 0.27, 0.27, 0.6)
	else:
		update_visual()

func play_clear_anim() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.parallel().tween_property(bg_rect, "modulate", Color(3.0, 3.0, 3.0, 1.0), 0.1)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.15)
	tween.tween_callback(func():
		clear_cell()
		scale = Vector2(1.0, 1.0)
	)

func play_bomb_anim() -> void:
	var tween = create_tween()
	bg_rect.color = Color(1.0, 0.4, 0.1, 1.0)
	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.12)
	tween.parallel().tween_property(bg_rect, "modulate", Color(4.0, 2.0, 1.0, 1.0), 0.12)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), 0.18)
	tween.tween_callback(func():
		clear_cell()
		scale = Vector2(1.0, 1.0)
	)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("cell_clicked", row, col)
	elif event is InputEventScreenTouch and event.pressed:
		emit_signal("cell_clicked", row, col)

func _on_mouse_entered() -> void:
	emit_signal("cell_hovered", row, col)
