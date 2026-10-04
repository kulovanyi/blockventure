extends Node

signal score_changed(new_score: int)
signal moves_changed(moves_left: int)
signal combo_changed(streak: int)
signal game_over_triggered(reason: String)

const BOARD_SIZE = 8

const COLOR_MAP = {
	"c-cyan": Color(0.13, 0.83, 0.93),
	"c-blue": Color(0.23, 0.51, 0.96),
	"c-orange": Color(0.98, 0.45, 0.09),
	"c-yellow": Color(0.96, 0.75, 0.14),
	"c-green": Color(0.13, 0.77, 0.37),
	"c-red": Color(0.94, 0.27, 0.27),
	"c-purple": Color(0.66, 0.33, 0.98),
	"c-pink": Color(0.93, 0.28, 0.6)
}

const SHAPES = [
	# 1x1 to 3x3 Squares
	{ "matrix": [[1]], "color": "c-cyan", "name": "dot" },
	{ "matrix": [[1, 1], [1, 1]], "color": "c-yellow", "name": "square_2x2" },
	{ "matrix": [[1, 1, 1], [1, 1, 1], [1, 1, 1]], "color": "c-red", "name": "square_3x3" },
	# Lines
	{ "matrix": [[1, 1]], "color": "c-orange", "name": "line_2h" },
	{ "matrix": [[1], [1]], "color": "c-orange", "name": "line_2v" },
	{ "matrix": [[1, 1, 1]], "color": "c-green", "name": "line_3h" },
	{ "matrix": [[1], [1], [1]], "color": "c-green", "name": "line_3v" },
	{ "matrix": [[1, 1, 1, 1]], "color": "c-cyan", "name": "line_4h" },
	{ "matrix": [[1], [1], [1], [1]], "color": "c-cyan", "name": "line_4v" },
	{ "matrix": [[1, 1, 1, 1, 1]], "color": "c-purple", "name": "line_5h" },
	{ "matrix": [[1], [1], [1], [1], [1]], "color": "c-purple", "name": "line_5v" },
	# L-Shapes & Corners
	{ "matrix": [[1, 0], [1, 1]], "color": "c-purple", "name": "corner_dl" },
	{ "matrix": [[0, 1], [1, 1]], "color": "c-purple", "name": "corner_dr" },
	{ "matrix": [[1, 1], [1, 0]], "color": "c-purple", "name": "corner_ul" },
	{ "matrix": [[1, 1], [0, 1]], "color": "c-purple", "name": "corner_ur" },
	{ "matrix": [[1, 0, 0], [1, 0, 0], [1, 1, 1]], "color": "c-pink", "name": "big_l" },
	# Rectangles & Plus
	{ "matrix": [[1, 1, 1], [1, 1, 1]], "color": "c-blue", "name": "rect_3x2" },
	{ "matrix": [[1, 1], [1, 1], [1, 1]], "color": "c-blue", "name": "rect_2x3" },
	{ "matrix": [[0, 1, 0], [1, 1, 1], [0, 1, 0]], "color": "c-cyan", "name": "plus" }
]

var game_mode: String = "classic" # "classic" or "adventure"
var score: int = 0
var combo_streak: int = 0
var session_coins: int = 0
var moves_left: int = 0
var is_game_active: bool = false
var active_powerup: String = ""

func start_game(mode: String) -> void:
	game_mode = mode
	score = 0
	combo_streak = 0
	session_coins = 0
	active_powerup = ""
	is_game_active = true
	
	if mode == "adventure":
		var extra = int(SaveManager.profile.get("upgrades", {}).get("extraMoves", 0))
		moves_left = 10 + extra
	else:
		moves_left = 0
		
	emit_signal("score_changed", score)
	emit_signal("moves_changed", moves_left)
	emit_signal("combo_changed", combo_streak)

func add_score(pts: int) -> void:
	score += pts
	emit_signal("score_changed", score)
	
	if game_mode == "classic":
		if score > int(SaveManager.profile.get("classicBest", 0)):
			SaveManager.profile["classicBest"] = score
			SaveManager.save_profile()
	else:
		if score > int(SaveManager.profile.get("adventureBest", 0)):
			SaveManager.profile["adventureBest"] = score
			SaveManager.save_profile()

func use_move() -> void:
	if game_mode != "adventure": return
	
	# Skip chance calculation
	var skip_lvl = int(SaveManager.profile.get("upgrades", {}).get("skipChance", 0))
	var skip_chance = skip_lvl * 0.004 # 0.4% per lvl
	if randf() < skip_chance:
		SoundManager.play_level_up()
		return
		
	moves_left -= 1
	emit_signal("moves_changed", moves_left)
	if moves_left <= 0:
		trigger_game_over("Elfogyott a lépésszámod!")

func trigger_game_over(reason: String) -> void:
	if not is_game_active: return
	is_game_active = false
	emit_signal("game_over_triggered", reason)

func get_random_shape() -> Dictionary:
	var idx = randi() % SHAPES.size()
	var template = SHAPES[idx]
	var mat: Array = []
	for row in template["matrix"]:
		var r_arr: Array = []
		for val in row:
			# 22% chance of coin block in adventure mode
			if val == 1 and game_mode == "adventure" and randf() < 0.22:
				r_arr.append(2)
			else:
				r_arr.append(val)
		mat.append(r_arr)
		
	return {
		"matrix": mat,
		"color": template["color"],
		"name": template["name"]
	}
