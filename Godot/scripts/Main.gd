extends Control

@onready var lbl_score: Label = $VBoxContainer/Header/ScoreCard/HBox/ScoreVal
@onready var lbl_best: Label = $VBoxContainer/Header/BestCard/HBox/BestVal
@onready var board: GridContainer = $VBoxContainer/BoardArea/Board
@onready var dock: HBoxContainer = $VBoxContainer/DockArea/Dock
@onready var combo_banner: Label = $VBoxContainer/ComboBanner
@onready var game_over_panel: ColorRect = $GameOverModal
@onready var btn_restart: Button = $GameOverModal/Panel/VBox/BtnRestart
@onready var lbl_final_score: Label = $GameOverModal/Panel/VBox/ScoreRow/FinalScore

var current_drag_data: Dictionary = {}

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.high_score_changed.connect(_on_high_score_changed)
	GameManager.game_over_triggered.connect(_on_game_over)
	
	dock.piece_drag_started.connect(_on_piece_drag_started)
	dock.piece_drag_updated.connect(_on_piece_drag_updated)
	dock.piece_drag_ended.connect(_on_piece_drag_ended)
	
	board.piece_placed.connect(_on_piece_placed)
	board.lines_cleared.connect(_on_lines_cleared)
	
	btn_restart.pressed.connect(_start_new_game)
	
	game_over_panel.visible = false
	combo_banner.visible = false
	
	_start_new_game()

func _start_new_game() -> void:
	game_over_panel.visible = false
	combo_banner.visible = false
	GameManager.start_new_game()
	board.reset_board()
	dock.reset_dock()
	lbl_score.text = "0"
	lbl_best.text = str(GameManager.high_score)

func _on_score_changed(new_score: int) -> void:
	lbl_score.text = str(new_score)

func _on_high_score_changed(new_best: int) -> void:
	lbl_best.text = str(new_best)

func _on_lines_cleared(count: int, combo: int) -> void:
	if combo > 1:
		combo_banner.text = "COMBO x%d! 🔥" % combo
		combo_banner.visible = true
		var tw = create_tween()
		tw.tween_property(combo_banner, "scale", Vector2(1.2, 1.2), 0.1)
		tw.tween_property(combo_banner, "scale", Vector2.ONE, 0.1)
		tw.tween_interval(1.0)
		tw.tween_callback(func(): combo_banner.visible = false)
	else:
		combo_banner.visible = false

func _on_piece_drag_started(data: Dictionary) -> void:
	current_drag_data = data

func _on_piece_drag_updated(pos: Vector2) -> void:
	var target = _get_grid_target(pos)
	if target != Vector2i(-1, -1):
		board.show_preview(current_drag_data["matrix"], target.x, target.y)
	else:
		board.clear_preview()

func _on_piece_drag_ended(data: Dictionary, pos: Vector2, slot_idx: int) -> void:
	board.clear_preview()
	var target = _get_grid_target(pos)
	
	if target != Vector2i(-1, -1):
		var placed = board.place_piece(data, target.x, target.y)
		if placed:
			dock.remove_piece(slot_idx)
			_check_game_over()
			return
			
	# Invalid drop -> return to dock
	var p = dock.slots[slot_idx]
	if p and is_instance_valid(p):
		p.return_to_dock()

func _get_grid_target(global_pos: Vector2) -> Vector2i:
	var board_rect = board.get_global_rect()
	if not board_rect.has_point(global_pos):
		return Vector2i(-1, -1)
		
	var local_pos = global_pos - board_rect.position
	var cell_w = board_rect.size.x / float(GameManager.BOARD_SIZE)
	var cell_h = board_rect.size.y / float(GameManager.BOARD_SIZE)
	
	var r = int(local_pos.y / cell_h)
	var c = int(local_pos.x / cell_w)
	
	var matrix = current_drag_data.get("matrix", [[1]])
	var offset_r = int(matrix.size() / 2)
	var offset_c = int(matrix[0].size() / 2)
	
	return Vector2i(r - offset_r, c - offset_c)

func _on_piece_placed() -> void:
	_check_game_over()

func _check_game_over() -> void:
	if not dock.has_playable_piece(board):
		GameManager.trigger_game_over()

func _on_game_over() -> void:
	lbl_final_score.text = str(GameManager.score)
	game_over_panel.visible = true
