extends Node

var muted: bool = false
var volume: float = 0.8

var audio_players: Array[AudioStreamPlayer] = []
const POOL_SIZE = 8

func _ready() -> void:
	for i in range(POOL_SIZE):
		var p = AudioStreamPlayer.new()
		add_child(p)
		audio_players.append(p)

func _get_available_player() -> AudioStreamPlayer:
	for p in audio_players:
		if not p.playing:
			return p
	return audio_players[0]

func set_muted(is_muted: bool) -> void:
	muted = is_muted

func set_volume(val: float) -> void:
	volume = clamp(val, 0.0, 1.0)
	var db = linear_to_db(volume) if volume > 0.001 else -80.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

func play_click() -> void:
	if muted: return
	_play_tone(600.0, 0.04, 0.15)

func play_pickup() -> void:
	if muted: return
	_play_tone(440.0, 0.08, 0.2)

func play_place() -> void:
	if muted: return
	_play_tone(220.0, 0.1, 0.3)

func play_clear(lines: int = 1, combo: int = 1) -> void:
	if muted: return
	var base_freq = 523.25 * (1.0 + (combo - 1) * 0.15)
	_play_tone(base_freq, 0.25, 0.35)

func play_coin() -> void:
	if muted: return
	_play_tone(987.77, 0.15, 0.25)

func play_powerup() -> void:
	if muted: return
	_play_tone(750.0, 0.2, 0.3)

func play_explosion() -> void:
	if muted: return
	_play_tone(120.0, 0.4, 0.5)

func play_level_up() -> void:
	if muted: return
	_play_tone(880.0, 0.3, 0.3)

func _play_tone(frequency: float, duration: float, amp: float) -> void:
	var player = _get_available_player()
	var sample_hz = 22050.0
	var total_samples = int(sample_hz * duration)
	
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = int(sample_hz)
	stream.stereo = false
	
	var data = PackedByteArray()
	data.resize(total_samples)
	
	for i in range(total_samples):
		var t = float(i) / sample_hz
		var env = 1.0 - (float(i) / float(total_samples)) # Linear decay
		var val = sin(t * frequency * TAU) * amp * env
		var byte_val = int(clamp((val + 1.0) * 0.5 * 255.0, 0.0, 255.0))
		data[i] = byte_val
		
	stream.data = data
	player.stream = stream
	player.play()
