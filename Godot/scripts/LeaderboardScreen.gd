extends Control

@onready var tab_classic: Button = $VBoxContainer/Tabs/BtnClassic
@onready var tab_adventure: Button = $VBoxContainer/Tabs/BtnAdventure
@onready var list_container: VBoxContainer = $VBoxContainer/ScrollContainer/ListContainer

var current_mode: String = "classic"

const FAKE_PLAYERS = [
	{ "name": "CyberBlaster", "classic": 18450, "adv": 2400 },
	{ "name": "NeonKnight", "classic": 14200, "adv": 1950 },
	{ "name": "PixelQueen", "classic": 11800, "adv": 1600 },
	{ "name": "QuantumStrike", "classic": 9400, "adv": 1250 },
	{ "name": "VortexRider", "classic": 7600, "adv": 900 }
]

func _ready() -> void:
	tab_classic.pressed.connect(func():
		current_mode = "classic"
		_refresh()
	)
	tab_adventure.pressed.connect(func():
		current_mode = "adventure"
		_refresh()
	)
	_refresh()

func _refresh() -> void:
	tab_classic.modulate = Color(1.2, 1.2, 1.2) if current_mode == "classic" else Color(0.7, 0.7, 0.7)
	tab_adventure.modulate = Color(1.2, 1.2, 1.2) if current_mode == "adventure" else Color(0.7, 0.7, 0.7)
	
	for child in list_container.get_children():
		child.queue_free()
		
	var my_best = SaveManager.profile.get("classicBest" if current_mode == "classic" else "adventureBest", 0)
	var my_name = SaveManager.profile.get("playerName", "Játékos")
	
	var all_players = FAKE_PLAYERS.duplicate(true)
	all_players.append({ "name": "%s (Te) 👑" % my_name, "classic": my_best, "adv": my_best })
	
	all_players.sort_custom(func(a, b):
		var score_a = a["classic"] if current_mode == "classic" else a["adv"]
		var score_b = b["classic"] if current_mode == "classic" else b["adv"]
		return score_a > score_b
	)
	
	for i in range(all_players.size()):
		var p = all_players[i]
		var score_val = p["classic"] if current_mode == "classic" else p["adv"]
		
		var panel = PanelContainer.new()
		var hb = HBoxContainer.new()
		
		var rank_lbl = Label.new()
		rank_lbl.text = "#%d" % (i + 1)
		rank_lbl.custom_minimum_size = Vector2(40, 0)
		
		var name_lbl = Label.new()
		name_lbl.text = p["name"]
		
		var score_lbl = Label.new()
		score_lbl.text = "%s Pont" % str(score_val)
		score_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		hb.add_child(rank_lbl)
		hb.add_child(name_lbl)
		hb.add_spacer(false)
		hb.add_child(score_lbl)
		panel.add_child(hb)
		list_container.add_child(panel)
