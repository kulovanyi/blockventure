extends Node

signal score_changed(new_score: int)
signal high_score_changed(new_high_score: int)
signal game_over_triggered

const BOARD_SIZE: int = 8

# Vibrant modern block colors
const COLORS = {
	"cyan": Color(0.12, 0.85, 0.95),
	"blue": Color(0.24, 0.55, 0.98),
	"orange": Color(1.0, 0.55, 0.15),
	"yellow": Color(1.0, 0.82, 0.2),
	"green": Color(0.2, 0.88, 0.45),
	"red": Color(0.95, 0.3, 0.35),
	"purple": Color(0.72, 0.35, 1.0),
	"pink": Color(1.0, 0.35, 0.68)
}

# 19 Classic Block Shapes
const SHAPES = [
	# 1x1, 2x2, 3x3 Squares
	{ "matrix": [[1]], "color": "cyan", "name": "dot" },
	{ "matrix": [[1, 1], [1, 1]], "color": "yellow", "name": "square_2x2" },
	{ "matrix": [[1, 1, 1], [1, 1, 1], [1, 1, 1]], "color": "red", "name": "square_3x3" },
	
	# Lines 2, 3, 4, 5 (Horizontal & Vertical)
	{ "matrix": [[1, 1]], "color": "orange", "name": "line_2h" },
	{ "matrix": [[1], [1]], "color": "orange", "name": "line_2v" },
	{ "matrix": [[1, 1, 1]], "color": "green", "name": "line_3h" },
	{ "matrix": [[1], [1], [1]], "color": "green", "name": "line_3v" },
	{ "matrix": [[1, 1, 1, 1]], "color": "cyan", "name": "line_4h" },
	{ "matrix": [[1], [1], [1], [1]], "color": "cyan", "name": "line_4v" },
	{ "matrix": [[1, 1, 1, 1, 1]], "color": "purple", "name": "line_5h" },
	{ "matrix": [[1], [1], [1], [1], [1]], "color": "purple", "name": "line_5v" },
	
	# Small Corners (2x2)
	{ "matrix": [[1, 0], [1, 1]], "color": "purple", "name": "corner_dl" },
	{ "matrix": [[0, 1], [1, 1]], "color": "purple", "name": "corner_dr" },
	{ "matrix": [[1, 1], [1, 0]], "color": "purple", "name": "corner_ul" },
	{ "matrix": [[1, 1], [0, 1]], "color": "purple", "name": "corner_ur" },
	
	# Big L (3x3)
	{ "matrix": [[1, 0, 0], [1, 0, 0], [1, 1, 1]], "color": "pink", "name": "big_l" },
	
	# Rectangles & Plus
	{ "matrix": [[1, 1, 1], [1, 1, 1]], "color": "blue", "name": "rect_3x2" },
	{ "matrix": [[1, 1], [1, 1], [1, 1]], "color": "blue", "name": "rect_2x3" },
	{ "matrix": [[0, 1, 0], [1, 1, 1], [0, 1, 0]], "color": "cyan", "name": "plus" }
]

var score: int = 0
var high_score: int = 0
var is_game_over: bool = false
var audio_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	load_high_score()
	_init_audio()

func _init_audio() -> void:
	for i in range(6):
		var p = AudioStreamPlayer.new()
		add_child(p)
		audio_players.append(p)

func _get_player() -> AudioStreamPlayer:
	for p in audio_players:
		if not p.playing:
			return p
	return audio_players[0]

func start_new_game() -> void:
	score = 0
	is_game_over = false
	emit_signal("score_changed", score)

func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)
	
	if score > high_score:
		high_score = score
		save_high_score()
		emit_signal("high_score_changed", high_score)

func trigger_game_over() -> void:
	if is_game_over: return
	is_game_over = true
	play_sound_game_over()
	emit_signal("game_over_triggered")

func get_random_shape() -> Dictionary:
	return SHAPES[randi() % SHAPES.size()]

func load_high_score() -> void:
	if FileAccess.file_exists("user://highscore.save"):
		var f = FileAccess.open("user://highscore.save", FileAccess.READ)
		if f:
			high_score = f.get_32()
			f.close()
	emit_signal("high_score_changed", high_score)

func save_high_score() -> void:
	var f = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	if f:
		f.store_32(high_score)
		f.close()

# Procedural Sound FX
func play_sound_pickup() -> void:
	_play_tone(420.0, 0.06, 0.15)

func play_sound_place() -> void:
	_play_tone(220.0, 0.08, 0.25)

func play_sound_clear(lines: int = 1) -> void:
	var freq = 520.0 + (lines - 1) * 80.0
	_play_tone(freq, 0.22, 0.35)

func play_sound_game_over() -> void:
	_play_tone(140.0, 0.35, 0.3)

func _play_tone(frequency: float, duration: float, volume: float) -> void:
	var p = _get_player()
	var rate = 22050.0
	var samples = int(rate * duration)
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = int(rate)
	stream.stereo = false
	
	var data = PackedByteArray()
	data.resize(samples)
	
	for i in range(samples):
		var t = float(i) / rate
		var env = 1.0 - (float(i) / float(samples))
		var val = sin(t * frequency * TAU) * volume * env
		data[i] = int(clamp((val + 1.0) * 0.5 * 255.0, 0.0, 255.0))
		
	stream.data = data
	p.stream = stream
	p.play()
