extends Control

signal drag_started(piece_data: Dictionary)
signal drag_updated(global_pos: Vector2)
signal drag_ended(piece_data: Dictionary, global_pos: Vector2)

const BLOCK_SIZE: float = 34.0
const BLOCK_GAP: float = 3.0

var piece_data: Dictionary = {}
var is_dragging: bool = false
var original_pos: Vector2 = Vector2.ZERO
var drag_offset_y: float = -70.0 # Lift shape above finger

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func init_piece(data: Dictionary) -> void:
	piece_data = data
	var matrix: Array = data.get("matrix", [[1]])
	var rows = matrix.size()
	var cols = matrix[0].size()
	
	var w = cols * BLOCK_SIZE + (cols - 1) * BLOCK_GAP
	var h = rows * BLOCK_SIZE + (rows - 1) * BLOCK_GAP
	custom_minimum_size = Vector2(w, h)
	size = custom_minimum_size
	queue_redraw()

func _draw() -> void:
	var matrix: Array = piece_data.get("matrix", [])
	var color_name: String = piece_data.get("color", "cyan")
	var c: Color = GameManager.COLORS.get(color_name, Color(0.2, 0.5, 0.9))
	
	for r in range(matrix.size()):
		for col_idx in range(matrix[r].size()):
			if matrix[r][col_idx] > 0:
				var x = col_idx * (BLOCK_SIZE + BLOCK_GAP)
				var y = r * (BLOCK_SIZE + BLOCK_GAP)
				var rect = Rect2(Vector2(x, y), Vector2(BLOCK_SIZE, BLOCK_SIZE))
				
				# Main Block
				draw_rect(rect, c, true, -1.0)
				# 3D Shine
				var shine = Rect2(Vector2(x + 2, y + 2), Vector2(BLOCK_SIZE - 4, (BLOCK_SIZE - 4) * 0.45))
				draw_rect(shine, Color(1, 1, 1, 0.22), true, -1.0)
				# Border
				draw_rect(rect, Color(1, 1, 1, 0.3), false, 1.0)

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
	scale = Vector2(1.25, 1.25)
	z_index = 50
	GameManager.play_sound_pickup()
	emit_signal("drag_started", piece_data)
	_update_drag(pos)

func _update_drag(pos: Vector2) -> void:
	var center_offset = size * scale * 0.5
	global_position = pos - center_offset + Vector2(0, drag_offset_y)
	emit_signal("drag_updated", global_position + center_offset)

func _end_drag(pos: Vector2) -> void:
	if not is_dragging: return
	is_dragging = false
	z_index = 0
	scale = Vector2.ONE
	var center_pos = global_position + (size * 0.5)
	emit_signal("drag_ended", piece_data, center_pos)

func return_to_dock() -> void:
	var tw = create_tween()
	tw.tween_property(self, "global_position", original_pos, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
