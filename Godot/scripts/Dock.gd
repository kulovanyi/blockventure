extends HBoxContainer

signal piece_drag_started(piece_data: Dictionary)
signal piece_drag_updated(pos: Vector2)
signal piece_drag_ended(piece_data: Dictionary, pos: Vector2, slot_idx: int)

const PieceScene = preload("res://scenes/Piece.tscn")

var slots: Array = [null, null, null]

func _ready() -> void:
	pass

func reset_dock() -> void:
	for i in range(3):
		if slots[i] != null:
			slots[i].queue_free()
			slots[i] = null
	spawn_pieces()

func spawn_pieces() -> void:
	for i in range(3):
		if slots[i] == null:
			_spawn_slot(i)

func _spawn_slot(idx: int) -> void:
	var slot_node = get_node_or_null("Slot%d" % idx)
	if not slot_node: return
	
	for child in slot_node.get_children():
		child.queue_free()
		
	var shape_data = GameManager.get_random_shape()
	var piece = PieceScene.instantiate()
	piece.init_piece(shape_data)
	
	piece.drag_started.connect(func(data): emit_signal("piece_drag_started", data))
	piece.drag_updated.connect(func(pos): emit_signal("piece_drag_updated", pos))
	piece.drag_ended.connect(func(data, pos): emit_signal("piece_drag_ended", data, pos, idx))
	
	slot_node.add_child(piece)
	slots[idx] = piece

func remove_piece(idx: int) -> void:
	if idx >= 0 and idx < 3 and slots[idx] != null:
		slots[idx].queue_free()
		slots[idx] = null
		
	var all_empty = true
	for p in slots:
		if p != null:
			all_empty = false
			break
			
	if all_empty:
		spawn_pieces()

func has_playable_piece(board_node) -> bool:
	for p in slots:
		if p != null and is_instance_valid(p):
			if board_node.can_piece_fit_anywhere(p.piece_data["matrix"]):
				return true
	return false
