extends Control

@onready var btn_watch_ad: Button = $ScrollContainer/VBoxContainer/FreeRewards/AdCard/HBox/BtnWatchAd
@onready var iap_grid: GridContainer = $ScrollContainer/VBoxContainer/IapGrid
@onready var items_grid: GridContainer = $ScrollContainer/VBoxContainer/ItemsGrid

const IAP_PACKS = [
	{ "id": "tier1", "name": "Kezdő Kincsesláda", "coins": 500, "price": "0.99 €", "icon": "🪙", "badge": "Népszerű" },
	{ "id": "tier2", "name": "Haladó Aranyzsák", "coins": 2500, "price": "3.99 €", "icon": "💰", "badge": "+25% Bónusz" },
	{ "id": "tier3", "name": "Mester Érmekas", "coins": 7000, "price": "9.99 €", "icon": "💎", "badge": "Legjobb Érték" },
	{ "id": "tier4", "name": "Bajnoki Széf", "coins": 16000, "price": "19.99 €", "icon": "👑", "badge": "VIP Bónusz" }
]

const SHOP_ITEMS = [
	{ "id": "item_bomb", "name": "Bomba Készlet", "icon": "💣", "qty": 3, "price": 150, "desc": "3x3-as területet robbant fel." },
	{ "id": "item_reroll", "name": "Forma Újradobó", "icon": "🔄", "qty": 5, "price": 100, "desc": "Újra cseréli a 3 dokkolt alakzatot." },
	{ "id": "item_moves", "name": "Extra Lépések", "icon": "⏳", "qty": 10, "price": 200, "desc": "Azonnali bónusz lépéseket ad." },
	{ "id": "item_magnet", "name": "Kvantum Mágnes", "icon": "🧲", "qty": 2, "price": 250, "desc": "Eltávolítja az azonos színű blokkokat." },
	{ "id": "item_shield", "name": "Védőpajzs", "icon": "🛡️", "qty": 2, "price": 300, "desc": "Kitisztítja a pálya közepét." },
	{ "id": "item_chest", "name": "Kincses Zsák", "icon": "💰", "qty": 500, "price": 350, "desc": "Azonnali 500 Arany érme." }
]

func _ready() -> void:
	btn_watch_ad.pressed.connect(_on_watch_ad)
	SaveManager.profile_updated.connect(refresh_shop)
	_build_shop()

func _build_shop() -> void:
	# Build IAP Cards
	for child in iap_grid.get_children():
		child.queue_free()
		
	for pack in IAP_PACKS:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(240, 160)
		var vb = VBoxContainer.new()
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var icon_lbl = Label.new()
		icon_lbl.text = pack["icon"]
		icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var title_lbl = Label.new()
		title_lbl.text = pack["name"]
		title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var amount_lbl = Label.new()
		amount_lbl.text = "+%s Arany 🪙" % str(pack["coins"])
		amount_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var btn_buy = Button.new()
		btn_buy.text = pack["price"]
		btn_buy.pressed.connect(func(): _buy_iap(pack))
		
		vb.add_child(icon_lbl)
		vb.add_child(title_lbl)
		vb.add_child(amount_lbl)
		vb.add_child(btn_buy)
		panel.add_child(vb)
		iap_grid.add_child(panel)
		
	refresh_shop()

func refresh_shop() -> void:
	# Build / update Consumable Item Cards
	for child in items_grid.get_children():
		child.queue_free()
		
	for item in SHOP_ITEMS:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(240, 180)
		var vb = VBoxContainer.new()
		vb.alignment = BoxContainer.ALIGNMENT_CENTER
		
		var icon_lbl = Label.new()
		icon_lbl.text = item["icon"]
		icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var title_lbl = Label.new()
		title_lbl.text = item["name"]
		title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var owned_cnt = SaveManager.get_item_count(item["id"])
		var owned_lbl = Label.new()
		if item["id"] != "item_chest":
			owned_lbl.text = "Birtokodban: %d db" % owned_cnt
			owned_lbl.modulate = Color(0.3, 0.9, 0.4) if owned_cnt > 0 else Color(0.6, 0.6, 0.6)
		else:
			owned_lbl.text = "+500 Érme bónusz"
		owned_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var btn_buy = Button.new()
		btn_buy.text = "%d 🪙 Megveszem (+%d)" % [item["price"], item["qty"]]
		btn_buy.pressed.connect(func(): _buy_item(item))
		
		vb.add_child(icon_lbl)
		vb.add_child(title_lbl)
		vb.add_child(owned_lbl)
		vb.add_child(btn_buy)
		panel.add_child(vb)
		items_grid.add_child(panel)

func _buy_iap(pack: Dictionary) -> void:
	SaveManager.add_coins(pack["coins"])
	SoundManager.play_coin()

func _buy_item(item: Dictionary) -> void:
	if SaveManager.get_coins() < item["price"]:
		SoundManager.play_click()
		return
		
	SaveManager.add_coins(-item["price"])
	if item["id"] == "item_chest":
		SaveManager.add_coins(item["qty"])
	else:
		var current = SaveManager.get_item_count(item["id"])
		SaveManager.set_item_count(item["id"], current + item["qty"])
		
	SoundManager.play_coin()
	refresh_shop()

func _on_watch_ad() -> void:
	SaveManager.add_coins(50)
	SoundManager.play_coin()
