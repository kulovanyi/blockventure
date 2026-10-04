extends Control

const FloatingTextScene = preload("res://scenes/vfx/FloatingText.tscn")

@onready var board: GridContainer = $VBoxContainer/BoardContainer/Board
@onready var dock: HBoxContainer = $VBoxContainer/DockContainer/Dock
@onready var score_label: Label = $VBoxContainer/HeaderBar/ScoreCard/ScoreValue
@onready var best_label: Label = $VBoxContainer/HeaderBar/BestCard/BestValue
@onready var moves_bar: HBoxContainer = $VBoxContainer/AdventureBar
@onready var moves_label: Label = $VBoxContainer/AdventureBar/MovesValue
@onready var combo_banner: Label = $VBoxContainer/ComboBanner
@onready var targeting_banner: HBoxContainer = $VBoxContainer/TargetingBanner

# Helper buttons & badges
@onready var btn_bomb: Button = $VBoxContainer/PowerupsBar/BtnBomb
@onready var badge_bomb: Label = $VBoxContainer/PowerupsBar/BtnBomb/Badge
@onready var btn_reroll: Button = $VBoxContainer/PowerupsBar/BtnReroll
@onready var badge_reroll: Label = $VBoxContainer/PowerupsBar/BtnReroll/Badge
@onready var btn_moves: Button = $VBoxContainer/PowerupsBar/BtnMoves
@onready var badge_moves: Label = $VBoxContainer/PowerupsBar/BtnMoves/Badge
@onready var btn_magnet: Button = $VBoxContainer/PowerupsBar/BtnMagnet
@onready var badge_magnet: Label = $VBoxContainer/PowerupsBar/BtnMagnet/Badge
@onready var btn_shield: Button = $VBoxContainer/PowerupsBar/BtnShield
@onready var badge_shield: Label = $VBoxContainer/PowerupsBar/BtnShield/Badge

var current_dragged_data: Dictionary = {}

func _ready() -> void:
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.moves_changed.connect(_on_moves_changed)
	GameManager.combo_changed.connect(_on_combo_changed)
	SaveManager.profile_updated.connect(update_powerups_ui)
	
	dock.piece_drag_started.connect(_on_piece_drag_started)
	dock.piece_drag_updated.connect(_on_piece_drag_updated)
	dock.piece_drag_ended.connect(_on_piece_drag_ended)
	
	board.piece_placed.connect(_on_piece_placed)
	board.lines_cleared.connect(_on_lines_cleared)
	board.bomb_executed.connect(_on_bomb_executed)
	
	btn_bomb.pressed.connect(_on_bomb_pressed)
	btn_reroll.pressed.connect(_on_reroll_pressed)
	btn_moves.pressed.connect(_on_moves_pressed)
	btn_magnet.pressed.connect(_on_magnet_pressed)
	btn_shield.pressed.connect(_on_shield_pressed)
	
	$VBoxContainer/TargetingBanner/BtnCancel.pressed.connect(_cancel_powerup)
	
	targeting_banner.visible = false
	combo_banner.visible = false

func start_game(mode: String) -> void:
	GameManager.start_game(mode)
	board.reset_board()
	dock.spawn_pieces()
	
	moves_bar.visible = (mode == "adventure")
	var best = SaveManager.profile.get("adventureBest" if mode == "adventure" else "classicBest", 0)
	best_label.text = str(best)
	score_label.text = "0"
	
	update_powerups_ui()

func _on_score_changed(new_score: int) -> void:
	score_label.text = str(new_score)

func _on_moves_changed(moves: int) -> void:
	moves_label.text = str(moves)

func _on_combo_changed(streak: int) -> void:
	if streak > 1:
		combo_banner.text = "COMBO x%d! 🔥" % streak
		combo_banner.visible = true
	else:
		combo_banner.visible = false

func update_powerups_ui() -> void:
	var b_cnt = SaveManager.get_item_count("item_bomb")
	var r_cnt = SaveManager.get_item_count("item_reroll")
	var m_cnt = SaveManager.get_item_count("item_moves")
	var mag_cnt = SaveManager.get_item_count("item_magnet")
	var s_cnt = SaveManager.get_item_count("item_shield")
	
	badge_bomb.text = str(b_cnt)
	badge_reroll.text = str(r_cnt)
	badge_moves.text = str(m_cnt)
	badge_magnet.text = str(mag_cnt)
	badge_shield.text = str(s_cnt)
	
	btn_bomb.disabled = (b_cnt <= 0)
	btn_reroll.disabled = (r_cnt <= 0)
	btn_moves.disabled = (m_cnt <= 0)
	btn_magnet.disabled = (mag_cnt <= 0)
	btn_shield.disabled = (s_cnt <= 0)

func _on_piece_drag_started(data: Dictionary) -> void:
	current_dragged_data = data

func _on_piece_drag_updated(pos: Vector2) -> void:
	var cell_pos = _get_board_cell_at_pos(pos)
	if cell_pos != Vector2i(-1, -1):
		board.show_preview(current_dragged_data["matrix"], cell_pos.x, cell_pos.y)
	else:
		board.clear_preview()

func _on_piece_drag_ended(data: Dictionary, pos: Vector2, slot_idx: int) -> void:
	board.clear_preview()
	var cell_pos = _get_board_cell_at_pos(pos)
	if cell_pos != Vector2i(-1, -1):
		var placed = board.place_piece(data, cell_pos.x, cell_pos.y)
		if placed:
			dock.remove_piece(slot_idx)
			GameManager.use_move()
			return
			
	# Failed drop -> return piece
	var p = dock.slots[slot_idx]
	if p: p.return_to_dock()

func _get_board_cell_at_pos(global_pos: Vector2) -> Vector2i:
	var board_rect = board.get_global_rect()
	if not board_rect.has_point(global_pos):
		return Vector2i(-1, -1)
		
	var local_pos = global_pos - board_rect.position
	var cell_w = board_rect.size.x / float(GameManager.BOARD_SIZE)
	var cell_h = board_rect.size.y / float(GameManager.BOARD_SIZE)
	
	var r = int(local_pos.y / cell_h)
	var c = int(local_pos.x / cell_w)
	
	# Offset to place piece centered on touch
	var matrix = current_dragged_data.get("matrix", [[1]])
	var offset_r = int(matrix.size() / 2)
	var offset_c = int(matrix[0].size() / 2)
	
	return Vector2i(r - offset_r, c - offset_c)

func _on_piece_placed() -> void:
	_check_game_over()

func _on_lines_cleared(count: int, combo: int) -> void:
	_spawn_floating_text("+%d Pont! (x%d Kombó)" % [count * 100 * combo, combo])
	_check_game_over()

func _on_bomb_executed(cleared: int) -> void:
	_cancel_powerup()
	_spawn_floating_text("💣 BUMM! -%d Kocka" % cleared)
	_check_game_over()

func _check_game_over() -> void:
	if not dock.has_any_playable_piece(board):
		GameManager.trigger_game_over("Nem tudsz több alakzatot letenni!")

func _on_bomb_pressed() -> void:
	if SaveManager.get_item_count("item_bomb") <= 0: return
	if GameManager.active_powerup == "bomb":
		_cancel_powerup()
		return
		
	GameManager.active_powerup = "bomb"
	SaveManager.use_item("item_bomb")
	targeting_banner.visible = true
	SoundManager.play_click()

func _on_reroll_pressed() -> void:
	if SaveManager.use_item("item_reroll"):
		dock.reroll_all()
		SoundManager.play_clear(1, 1)
		_spawn_floating_text("🔄 Új formák!")
		update_powerups_ui()

func _on_moves_pressed() -> void:
	if SaveManager.use_item("item_moves"):
		if GameManager.game_mode == "adventure":
			GameManager.moves_left += 5
			GameManager.emit_signal("moves_changed", GameManager.moves_left)
			_spawn_floating_text("⏳ +5 Lépés!")
		else:
			GameManager.add_score(500)
			_spawn_floating_text("⏳ +500 Bónusz!")
		SoundManager.play_level_up()
		update_powerups_ui()

func _on_magnet_pressed() -> void:
	if SaveManager.use_item("item_magnet"):
		var c = board.execute_magnet()
		_spawn_floating_text("🧲 -%d Kocka!" % c)
		update_powerups_ui()

func _on_shield_pressed() -> void:
	if SaveManager.use_item("item_shield"):
		var c = board.execute_shield()
		_spawn_floating_text("🛡️ Közép tisztítva!")
		update_powerups_ui()

func _cancel_powerup() -> void:
	GameManager.active_powerup = ""
	targeting_banner.visible = false
	board.clear_bomb_highlights()

func _spawn_floating_text(txt: String) -> void:
	var ft = FloatingTextScene.instantiate()
	add_child(ft)
	ft.show_text(txt, size * 0.5)
