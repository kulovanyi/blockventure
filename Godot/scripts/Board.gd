extends GridContainer

signal lines_cleared(count: int, combo: int)
signal piece_placed

const CellScene = preload("res://scenes/Cell.tscn")

var cells: Array = [] # 8x8 2D array of Cell nodes
var grid_data: Array = [] # 8x8 2D array of null or color String
var combo_streak: int = 0

func _ready() -> void:
	columns = GameManager.BOARD_SIZE
	_build_board()

func _build_board() -> void:
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
			add_child(cell)
			row_cells.append(cell)
			row_data.append(null)
		cells.append(row_cells)
		grid_data.append(row_data)

func reset_board() -> void:
	combo_streak = 0
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
			if matrix[r][c] > 0:
				grid_data[start_r + r][start_c + c] = color_name
				cells[start_r + r][start_c + c].set_filled(color_name)
				placed_blocks += 1
				
	GameManager.play_sound_place()
	GameManager.add_score(placed_blocks * 10)
	
	_check_lines()
	emit_signal("piece_placed")
	return true

func _check_lines() -> void:
	var full_rows: Array = []
	var full_cols: Array = []
	
	# Check horizontal rows
	for r in range(GameManager.BOARD_SIZE):
		var row_full = true
		for c in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] == null:
				row_full = false
				break
		if row_full:
			full_rows.append(r)
			
	# Check vertical columns
	for c in range(GameManager.BOARD_SIZE):
		var col_full = true
		for r in range(GameManager.BOARD_SIZE):
			if grid_data[r][c] == null:
				col_full = false
				break
		if col_full:
			full_cols.append(c)
			
	var total_lines = full_rows.size() + full_cols.size()
	
	if total_lines > 0:
		combo_streak += 1
		var cells_to_clear = {}
		
		for r in full_rows:
			for c in range(GameManager.BOARD_SIZE):
				cells_to_clear[Vector2i(r, c)] = true
				
		for c in full_cols:
			for r in range(GameManager.BOARD_SIZE):
				cells_to_clear[Vector2i(r, c)] = true
				
		for pos in cells_to_clear.keys():
			var r = pos.x
			var c = pos.y
			grid_data[r][c] = null
			cells[r][c].play_clear_animation()
			
		var earned_score = total_lines * 100 * combo_streak
		GameManager.add_score(earned_score)
		GameManager.play_sound_clear(total_lines)
		emit_signal("lines_cleared", total_lines, combo_streak)
	else:
		combo_streak = 0

func show_preview(matrix: Array, start_r: int, start_c: int) -> void:
	clear_preview()
	if not can_place_piece(matrix, start_r, start_c): return
	
	var rows = matrix.size()
	var cols = matrix[0].size()
	
	# Light up preview cells
	for r in range(rows):
		for c in range(cols):
			if matrix[r][c] > 0:
				cells[start_r + r][start_c + c].set_preview(true)
				
	# Check which rows and columns would clear
	for r in range(GameManager.BOARD_SIZE):
		var will_clear = true
		for c in range(GameManager.BOARD_SIZE):
			var has_grid = (grid_data[r][c] != null)
			var in_piece = (r >= start_r and r < start_r + rows and c >= start_c and c < start_c + cols and matrix[r - start_r][c - start_c] > 0)
			if not has_grid and not in_piece:
				will_clear = false
				break
		if will_clear:
			for c in range(GameManager.BOARD_SIZE):
				cells[r][c].set_will_clear(true)
				
	for c in range(GameManager.BOARD_SIZE):
		var will_clear = true
		for r in range(GameManager.BOARD_SIZE):
			var has_grid = (grid_data[r][c] != null)
			var in_piece = (r >= start_r and r < start_r + rows and c >= start_c and c < start_c + cols and matrix[r - start_r][c - start_c] > 0)
			if not has_grid and not in_piece:
				will_clear = false
				break
		if will_clear:
			for r in range(GameManager.BOARD_SIZE):
				cells[r][c].set_will_clear(true)

func clear_preview() -> void:
	for r in range(GameManager.BOARD_SIZE):
		for c in range(GameManager.BOARD_SIZE):
			cells[r][c].set_preview(false)
			cells[r][c].set_will_clear(false)
