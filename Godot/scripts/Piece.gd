extends Control

signal drag_started(piece_data: Dictionary)
signal drag_updated(global_pos: Vector2)
signal drag_ended(piece_data: Dictionary, global_pos: Vector2)

var piece_data: Dictionary = {}
var is_dragging: bool = false
var original_pos: Vector2 = Vector2.ZERO
var drag_offset: Vector2 = Vector2(0, -60) # Lift up above finger

@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func init_piece(data: Dictionary) -> void:
	piece_data = data
	_render_piece()

func _render_piece() -> void:
	for child in grid_container.get_children():
		child.queue_free()
		
	var matrix: Array = piece_data.get("matrix", [[1]])
	var color_name: String = piece_data.get("color", "c-cyan")
	var c_color = GameManager.COLOR_MAP.get(color_name, Color(0.2, 0.4, 0.8))
	
	grid_container.columns = matrix[0].size()
	
	for r in range(matrix.size()):
		for c in range(matrix[r].size()):
			var val = matrix[r][c]
			var block = ColorRect.new()
			block.custom_minimum_size = Vector2(36, 36)
			if val > 0:
				block.color = c_color
				if val == 2: # Coin block
					var coin = Label.new()
					coin.text = "🪙"
					coin.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
					coin.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
					block.add_child(coin)
			else:
				block.color = Color(0, 0, 0, 0)
			grid_container.add_child(block)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag(event.global_position)
		else:
			_end_drag(event.global_position)
	elif event is InputEventScreenTouch:
		if event.pressed:
			_start_drag(event.position)
		else:
			_end_drag(event.position)
	elif event is InputEventMouseMotion and is_dragging:
		_update_drag(event.global_position)
	elif event is InputEventScreenDrag and is_dragging:
		_update_drag(event.position)

func _start_drag(pos: Vector2) -> void:
	is_dragging = true
	original_pos = global_position
	scale = Vector2(1.2, 1.2)
	z_index = 50
	SoundManager.play_pickup()
	emit_signal("drag_started", piece_data)
	_update_drag(pos)

func _update_drag(pos: Vector2) -> void:
	global_position = pos + drag_offset - (size * scale * 0.5)
	emit_signal("drag_updated", global_position + (size * scale * 0.5))

func _end_drag(pos: Vector2) -> void:
	if not is_dragging: return
	is_dragging = false
	z_index = 0
	scale = Vector2(1.0, 1.0)
	emit_signal("drag_ended", piece_data, global_position + (size * 0.5))

func return_to_dock() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_pos, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
