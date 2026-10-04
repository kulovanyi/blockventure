extends Node

signal profile_updated
signal coins_changed(new_amount: int)

const SAVE_PATH = "user://save_data.json"

var profile: Dictionary = {
	"playerName": "Játékos",
	"avatarIcon": "🧑‍🚀",
	"coins": 150,
	"totalCoinsEarned": 150,
	"classicBest": 0,
	"adventureBest": 0,
	"upgrades": {
		"extraMoves": 0,
		"skipChance": 0,
		"coinBonus": 0,
		"comboBoost": 0
	},
	"inventory": {
		"item_bomb": 2,
		"item_reroll": 3,
		"item_moves": 2,
		"item_magnet": 1,
		"item_shield": 1
	},
	"stats": {
		"lines": 0,
		"combos": 0,
		"blocksPlaced": 0,
		"advBlocksPlaced": 0,
		"coinsCollected": 0,
		"maxCombo": 1
	},
	"achievementTiers": {},
	"achievementXp": 0,
	"lastDailyClaim": ""
}

func _ready() -> void:
	load_profile()

func load_profile() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_profile()
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK and typeof(json.data) == TYPE_DICTIONARY:
			var loaded: Dictionary = json.data
			for key in loaded.keys():
				profile[key] = loaded[key]
		file.close()
	emit_signal("profile_updated")

func save_profile() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(profile, "\t")
		file.store_string(json_string)
		file.close()
	emit_signal("profile_updated")

func add_coins(amount: int) -> void:
	profile["coins"] = int(profile.get("coins", 0)) + amount
	profile["totalCoinsEarned"] = int(profile.get("totalCoinsEarned", 0)) + amount
	var stats = profile.get("stats", {})
	stats["coinsCollected"] = int(stats.get("coinsCollected", 0)) + amount
	profile["stats"] = stats
	save_profile()
	emit_signal("coins_changed", profile["coins"])

func get_coins() -> int:
	return int(profile.get("coins", 0))

func get_item_count(item_id: String) -> int:
	var inv: Dictionary = profile.get("inventory", {})
	return int(inv.get(item_id, 0))

func set_item_count(item_id: String, count: int) -> void:
	if not profile.has("inventory"):
		profile["inventory"] = {}
	profile["inventory"][item_id] = max(0, count)
	save_profile()

func use_item(item_id: String) -> bool:
	var count = get_item_count(item_id)
	if count > 0:
		set_item_count(item_id, count - 1)
		return true
	return false
