extends Control

@onready var upgrades_grid: GridContainer = $ScrollContainer/VBoxContainer/UpgradesGrid

const UPGRADES_DEF = [
	{ "id": "extraMoves", "name": "Kezdőlépések", "icon": "⏳", "maxLvl": 50, "baseCost": 50, "desc": "Növeli a Kaland mód kezdő lépésszámát." },
	{ "id": "skipChance", "name": "Ingyen Lépés", "icon": "🎲", "maxLvl": 25, "baseCost": 80, "desc": "Esély arra, hogy egy lépés ne fogyasszon kört." },
	{ "id": "coinBonus", "name": "Érmemágnes", "icon": "🪙", "maxLvl": 30, "baseCost": 60, "desc": "Megnöveli a táblán megjelenő aranyérmék számát." },
	{ "id": "comboBoost", "name": "Kombó Erősítő", "icon": "🔥", "maxLvl": 40, "baseCost": 100, "desc": "Több pontot ad minden egymást követő kombóért." }
]

func _ready() -> void:
	SaveManager.profile_updated.connect(refresh_upgrades)
	refresh_upgrades()

func refresh_upgrades() -> void:
	for child in upgrades_grid.get_children():
		child.queue_free()
		
	var upgs: Dictionary = SaveManager.profile.get("upgrades", {})
	
	for def in UPGRADES_DEF:
		var lvl = int(upgs.get(def["id"], 0))
		var is_max = (lvl >= def["maxLvl"])
		var next_cost = def["baseCost"] * (lvl + 1)
		
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(240, 180)
		var vb = VBoxContainer.new()
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var icon_lbl = Label.new()
		icon_lbl.text = def["icon"]
		icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var title_lbl = Label.new()
		title_lbl.text = def["name"]
		title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var lvl_lbl = Label.new()
		lvl_lbl.text = "Szint: %d / %d" % [lvl, def["maxLvl"]]
		lvl_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var btn_buy = Button.new()
		if is_max:
			btn_buy.text = "MAX SZINT ✓"
			btn_buy.disabled = true
		else:
			btn_buy.text = "%d 🪙 Fejlesztés" % next_cost
			btn_buy.disabled = (SaveManager.get_coins() < next_cost)
			btn_buy.pressed.connect(func(): _upgrade(def, next_cost))
			
		vb.add_child(icon_lbl)
		vb.add_child(title_lbl)
		vb.add_child(lvl_lbl)
		vb.add_child(btn_buy)
		panel.add_child(vb)
		upgrades_grid.add_child(panel)

func _upgrade(def: Dictionary, cost: int) -> void:
	if SaveManager.get_coins() < cost: return
	
	SaveManager.add_coins(-cost)
	var current_lvl = int(SaveManager.profile["upgrades"].get(def["id"], 0))
	SaveManager.profile["upgrades"][def["id"]] = current_lvl + 1
	SaveManager.save_profile()
	SoundManager.play_level_up()
	refresh_upgrades()
