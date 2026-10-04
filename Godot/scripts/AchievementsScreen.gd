extends Control

@onready var rank_title_lbl: Label = $ScrollContainer/VBoxContainer/HeroCard/VBox/RankTitle
@onready var rank_sub_lbl: Label = $ScrollContainer/VBoxContainer/HeroCard/VBox/RankSub
@onready var xp_bar: ProgressBar = $ScrollContainer/VBoxContainer/HeroCard/VBox/ProgressBar
@onready var xp_text: Label = $ScrollContainer/VBoxContainer/HeroCard/VBox/XpText
@onready var list_container: VBoxContainer = $ScrollContainer/VBoxContainer/AchievementsList

const RANKS = [
	{ "name": "Kezdő Blaszter", "icon": "👑", "minXp": 0, "maxXp": 150 },
	{ "name": "Ügyes Építő", "icon": "⭐", "minXp": 150, "maxXp": 400 },
	{ "name": "Kombó Lovag", "icon": "🔥", "minXp": 400, "maxXp": 850 },
	{ "name": "Kvantum Mester", "icon": "💎", "minXp": 850, "maxXp": 1500 },
	{ "name": "Galaktikus Bajnok", "icon": "🏆", "minXp": 1500, "maxXp": 3000 }
]

func _ready() -> void:
	SaveManager.profile_updated.connect(refresh_achievements)
	refresh_achievements()

func refresh_achievements() -> void:
	var total_xp = int(SaveManager.profile.get("achievementXp", 0))
	var stats: Dictionary = SaveManager.profile.get("stats", {})
	var tiers: Dictionary = SaveManager.profile.get("achievementTiers", {})
	
	# Compute rank
	var current_rank = RANKS[0]
	for r in RANKS:
		if total_xp >= r["minXp"]:
			current_rank = r
			
	rank_title_lbl.text = "%s %s" % [current_rank["icon"], current_rank["name"]]
	rank_sub_lbl.text = "Összes gyűjtött XP: %d" % total_xp
	
	var xp_in_tier = total_xp - current_rank["minXp"]
	var tier_range = max(1, current_rank["maxXp"] - current_rank["minXp"])
	xp_bar.max_value = tier_range
	xp_bar.value = clamp(xp_in_tier, 0, tier_range)
	xp_text.text = "%d / %d XP" % [xp_in_tier, tier_range]
	
	# Build achievements
	for child in list_container.get_children():
		child.queue_free()
		
	# 1. Blocks Placed (starts at 150, 1.5x)
	var b_tier = int(tiers.get("blocks", 0))
	var b_target = int(round(150.0 * pow(1.5, b_tier)))
	var b_current = int(stats.get("blocksPlaced", 0))
	_create_ach_card("blocks", "🧱 Kockák Lehelyezése", "Helyezz le összesen %d blokkot a táblára!" % b_target, b_current, b_target, 50 * (b_tier + 1))
	
	# 2. Lines Cleared (starts at 20)
	var l_tier = int(tiers.get("lines", 0))
	var l_target = int(round(20.0 * pow(1.4, l_tier)))
	var l_current = int(stats.get("lines", 0))
	_create_ach_card("lines", "⚡ Sorok & Oszlopok", "Törölj ki %d teljes sort vagy oszlopot!" % l_target, l_current, l_target, 60 * (l_tier + 1))
	
	# 3. Combos (starts at 1, +1 per level)
	var c_tier = int(tiers.get("combos", 0))
	var c_target = 1 + c_tier
	var c_current = int(stats.get("combos", 0))
	_create_ach_card("combos", "🔥 Kombó Mester", "Hozz létre legalább %d kombót a játékban!" % c_target, c_current, c_target, 40 * (c_tier + 1))

func _create_ach_card(ach_id: String, title: String, desc: String, current: int, target: int, reward_coins: int) -> void:
	var panel = PanelContainer.new()
	var vb = VBoxContainer.new()
	
	var title_lbl = Label.new()
	title_lbl.text = title
	
	var desc_lbl = Label.new()
	desc_lbl.text = desc
	desc_lbl.modulate = Color(0.7, 0.7, 0.7)
	
	var progress = ProgressBar.new()
	progress.max_value = target
	progress.value = min(current, target)
	
	var hb = HBoxContainer.new()
	var prog_lbl = Label.new()
	prog_lbl.text = "%d / %d" % [min(current, target), target]
	
	var btn_claim = Button.new()
	var is_ready = (current >= target)
	btn_claim.text = "+%d 🪙 Átvétel" % reward_coins
	btn_claim.disabled = not is_ready
	btn_claim.pressed.connect(func():
		var tiers: Dictionary = SaveManager.profile.get("achievementTiers", {})
		tiers[ach_id] = int(tiers.get(ach_id, 0)) + 1
		SaveManager.profile["achievementTiers"] = tiers
		SaveManager.profile["achievementXp"] = int(SaveManager.profile.get("achievementXp", 0)) + reward_coins
		SaveManager.add_coins(reward_coins)
		SoundManager.play_level_up()
		refresh_achievements()
	)
	
	hb.add_child(prog_lbl)
	hb.add_spacer(false)
	hb.add_child(btn_claim)
	
	vb.add_child(title_lbl)
	vb.add_child(desc_lbl)
	vb.add_child(progress)
	vb.add_child(hb)
	panel.add_child(vb)
	list_container.add_child(panel)
