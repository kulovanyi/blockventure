extends GridContainer

signal lines_cleared(count: int, combo: int)
signal piece_placed
signal bomb_executed(cleared_count: int)

const CellScene = preload("res://scenes/components/Cell.tscn")
var cells: Array = [] # 8x8 2D array of Cell nodes
var grid_data: Array = [] # 8x8 null or { "color": ..., "has_coin": ... }

func _ready() -> void:
	columns = GameManager.BOARD_SIZE
	_init_board()

func _init_board() -> void:
	for child in get_children():
		child.queue_free()
	cells.clear()
	grid_data.clear()
	
	for r in range(GameManager.BOARD_SIZE):
		var row_cells: Array = []
		var row_data: Array = []
		for c in range(GameManager.BOARD_SIZE):
			var cell = CellScene.instantiate()
			cell.init_cell(r, c)
			cell.cell_clicked.connect(_on_cell_clicked)
			cell.cell_hovered.connect(_on_cell_hovered)
			add_child(cell)
			row_cells.append(cell)
			row_data.append(null)
		cells.append(row_cells)
		grid_data.append(row_data)

func reset_board() -> void:
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			grid_data[r][c] = null
			cells[r][c].clear_cell()

func can_place_piece(matrix: Array, start_r: int, start_c: int) -> bool:
	var rows = matrix.size()
	var cols = matrix[0].size()
	
	if start_r < 0 or start_r + rows > GameManager.BOARD_SIZE: return false
	if start_c < 0 or start_c + cols > GameManager.BOARD_SIZE: return false
	
	for r in range(rows):
		for c in range(cols):
			if matrix[r][c] > 0:
				if grid_data[start_r + r][start_c + c] != null:
					return false
	return true

func can_piece_fit_anywhere(matrix: Array) -> bool:
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			if can_place_piece(matrix, r, c):
				return true
	return false

func place_piece(piece_data: Dictionary, start_r: int, start_c: int) -> bool:
	var matrix: Array = piece_data["matrix"]
	var color_name: String = piece_data["color"]
	
	if not can_place_piece(matrix, start_r, start_c):
		return false
		
	var placed_blocks = 0
	for r in range(matrix.size()):
		for c in range(matrix[r].size()):
			var val = matrix[r][c]
			if val > 0:
				var with_coin = (val == 2)
				grid_data[start_r + r][start_c + c] = {
					"color": color_name,
					"has_coin": with_coin
				}
				cells[start_r + r][start_c + c].set_filled(color_name, with_coin)
				placed_blocks += 1
				
	SoundManager.play_place()
	GameManager.add_score(placed_blocks * 10)
	SaveManager.profile["stats"]["blocksPlaced"] = int(SaveManager.profile["stats"].get("blocksPlaced", 0)) + placed_blocks
	
	_check_and_clear_lines()
	emit_signal("piece_placed")
	return true

func _check_and_clear_lines() -> void:
	var full_rows: Array = []
	var full_cols: Array = []
	
	for r in range(GameManager.BOARD_SIZE):
		var row_full = true
		for c in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] == null:
				row_full = false
				break
		if row_full: full_rows.append(r)
		
	for c in range(GameManager.BOARD_SIZE):
		var col_full = true
		for r in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] == null:
				col_full = false
				break
		if col_full: full_cols.append(c)
		
	var total_lines = full_rows.size() + full_cols.size()
	if total_lines > 0:
		GameManager.combo_streak += 1
		var coins_earned = 0
		var cleared_cells = {}
		
		for r in full_rows:
			for c in range(GameManager.BOARD_SIZE):
				cleared_cells[Vector2i(r, c)] = true
				
		for c in full_cols:
			for r in range(GameManager.BOARD_SIZE):
				cleared_cells[Vector2i(r, c)] = true
				
		for pos in cleared_cells.keys():
			var r = pos.x
			var c = pos.y
			if grid_data[r][c] != null and grid_data[r][c].get("has_coin", false):
				coins_earned += 10
			grid_data[r][c] = null
			cells[r][c].play_clear_anim()
			
		if coins_earned > 0:
			SaveManager.add_coins(coins_earned)
			SoundManager.play_coin()
			
		var pts = total_lines * 100 * GameManager.combo_streak
		GameManager.add_score(pts)
		SoundManager.play_clear(total_lines, GameManager.combo_streak)
		
		# Update stats
		SaveManager.profile["stats"]["lines"] = int(SaveManager.profile["stats"].get("lines", 0)) + total_lines
		SaveManager.profile["stats"]["combos"] = int(SaveManager.profile["stats"].get("combos", 0)) + 1
		SaveManager.save_profile()
		
		emit_signal("lines_cleared", total_lines, GameManager.combo_streak)
	else:
		GameManager.combo_streak = 0
		GameManager.emit_signal("combo_changed", 0)

func execute_bomb(center_r: int, center_c: int) -> int:
	var cleared_count = 0
	var coins = 0
	
	for dr in range(-1, 2):
		for dc in range(-1, 2):
			var nr = center_r + dr
			var nc = center_c + dc
			if nr >= 0 and nr < GameManager.BOARD_SIZE and nc >= 0 and nc < GameManager.BOARD_SIZE:
				if grid_data[nr][nc] != null:
					if grid_data[nr][nc].get("has_coin", false):
						coins += 10
					grid_data[nr][nc] = null
					cleared_count += 1
				cells[nr][nc].play_bomb_anim()
				
	if coins > 0:
		SaveManager.add_coins(coins)
		SoundManager.play_coin()
		
	SoundManager.play_explosion()
	GameManager.add_score(cleared_count * 25 + 50)
	emit_signal("bomb_executed", cleared_count)
	return cleared_count

func execute_magnet() -> int:
	var color_counts = {}
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] != null:
				var col = grid_data[r][c]["color"]
				color_counts[col] = color_counts.get(col, 0) + 1
				
	var dominant_color = ""
	var max_count = 0
	for col in color_counts.keys():
		if color_counts[col] > max_count:
			max_count = color_counts[col]
			dominant_color = col
			
	if dominant_color == "" or max_count == 0: return 0
	
	var cleared_count = 0
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] != null and grid_data[r][c]["color"] == dominant_color:
				grid_data[r][c] = null
				cells[r][c].play_clear_anim()
				cleared_count += 1
				
	SoundManager.play_clear(2, 2)
	GameManager.add_score(cleared_count * 20)
	return cleared_count

func execute_shield() -> int:
	var cleared_count = 0
	for r in range(2, 6):
		for c in range(2, 6):
			if grid_data[r][c] != null:
				grid_data[r][c] = null
				cells[r][c].play_clear_anim()
				cleared_count += 1
	SoundManager.play_level_up()
	GameManager.add_score(cleared_count * 15 + 100)
	return cleared_count

func show_preview(matrix: Array, start_r: int, start_c: int) -> void:
	clear_preview()
	if not can_place_piece(matrix, start_r, start_c): return
	
	for r in range(matrix.size()):
		for c in range(matrix[r].size()):
			if matrix[r][c] > 0:
				cells[start_r + r][start_c + c].set_preview(true)

func clear_preview() -> void:
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			cells[r][c].set_preview(false)

func highlight_bomb_area(center_r: int, center_c: int) -> void:
	clear_bomb_highlights()
	for dr in range(-1, 2):
		for dc in range(-1, 2):
			var nr = center_r + dr
			var nc = center_c + dc
			if nr >= 0 and nr < GameManager.BOARD_SIZE and nc >= 0 and nc < GameManager.BOARD_SIZE:
				cells[nr][nc].set_targeting_hover(true)

func clear_bomb_highlights() -> void:
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			cells[r][c].set_targeting_hover(false)

func _on_cell_clicked(r: int, c: int) -> void:
	if GameManager.active_powerup == "bomb":
		execute_bomb(r, c)
		GameManager.active_powerup = ""
		clear_bomb_highlights()

func _on_cell_hovered(r: int, c: int) -> void:
	if GameManager.active_powerup == "bomb":
		highlight_bomb_area(r, c)
