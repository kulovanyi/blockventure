extends Control

@onready var shelf_view: Control = $ShelfView
@onready var reader_view: Control = $ReaderView
@onready var book_title_lbl: Label = $ReaderView/VBoxContainer/BookTitle
@onready var page_num_lbl: Label = $ReaderView/VBoxContainer/PageNum
@onready var page_text_lbl: Label = $ReaderView/VBoxContainer/PageContent/ScrollContainer/PageText
@onready var btn_prev: Button = $ReaderView/VBoxContainer/NavButtons/BtnPrev
@onready var btn_next: Button = $ReaderView/VBoxContainer/NavButtons/BtnNext

const BOOKS_DATA = [
	{
		"id": "book_relics",
		"title": "Ősi Erelyék Krónikája",
		"icon": "📜",
		"pages": [
			"1. Oldal:\n\nA blokkok nem csupán egyszerű geometriai formák. A régiek szerint mindegyik egy-egy dimenziókaput rejt, amely a kvantum-univerzum energiáját csatornázza be a rácsba.",
			"2. Oldal:\n\nAmikor egy teljes sor vagy oszlop megtelik azonos rezonanciájú kristályokkal, a blokkok atomi szinten felbomlanak, és tiszta arany energiát szabadítanak fel.",
			"3. Oldal:\n\nA Mester Blaszterek képesek megnyitni a titkos időkódokat. Aki mind a 8x8 mezőt uralni tudja, az képes átlépni a végtelen szintek kapuján."
		]
	},
	{
		"id": "book_quantum",
		"title": "Kvantum Kódex",
		"icon": "🔮",
		"pages": [
			"1. Oldal:\n\nA tér-idő rács 64 koordinátából áll. Minden lerakott alakzat megváltoztatja a tábla gravitációs mezejét, előkészítve a következő lépést.",
			"2. Oldal:\n\nA Kvantum Mágnes technológiája képes a kaotikus színmintákból kivonni a legdominánsabb hullámhosszt, azonnal elpárologtatva az összes egyező elemet.",
			"3. Oldal:\n\nHa kombókat láncolsz össze, az energiahullámok megsokszorozódnak. A 4x kombó feletti állapotban az időlépések szinte megállnak."
		]
	},
	{
		"id": "book_void",
		"title": "Üresség Krónikák",
		"icon": "🌌",
		"pages": [
			"1. Oldal:\n\nA sötét űr mélyén sodródó szilánkok a Kaland módban fedezhetők fel. Minden elveszett pergamenlap közelebb visz a blokkok eredetének megértéséhez.",
			"2. Oldal:\n\nA Védőpajzs aktiválásakor a rács magja stabilizálódik, kitisztítva a központi 4x4-es zónát a túlterheléstől.",
			"3. Oldal:\n\nAki elsajátítja a három könyv összes tanítását, a Block Venture igazi Bajnokává válik!"
		]
	}
]

var current_book_idx: int = 0
var current_page_idx: int = 0

func _ready() -> void:
	$ShelfView/VBoxContainer/BookGrid/Book1/BtnOpen.pressed.connect(func(): _open_book(0))
	$ShelfView/VBoxContainer/BookGrid/Book2/BtnOpen.pressed.connect(func(): _open_book(1))
	$ShelfView/VBoxContainer/BookGrid/Book3/BtnOpen.pressed.connect(func(): _open_book(2))
	
	$ReaderView/VBoxContainer/BtnBackShelf.pressed.connect(_back_to_shelf)
	btn_prev.pressed.connect(_prev_page)
	btn_next.pressed.connect(_next_page)
	
	_back_to_shelf()

func _open_book(idx: int) -> void:
	current_book_idx = idx
	current_page_idx = 0
	shelf_view.visible = false
	reader_view.visible = true
	SoundManager.play_click()
	_update_reader()

func _back_to_shelf() -> void:
	shelf_view.visible = true
	reader_view.visible = false
	SoundManager.play_click()

func _prev_page() -> void:
	if current_page_idx > 0:
		current_page_idx -= 1
		SoundManager.play_pickup()
		_update_reader()

func _next_page() -> void:
	var book = BOOKS_DATA[current_book_idx]
	if current_page_idx < book["pages"].size() - 1:
		current_page_idx += 1
		SoundManager.play_pickup()
		_update_reader()

func _update_reader() -> void:
	var book = BOOKS_DATA[current_book_idx]
	book_title_lbl.text = "%s %s" % [book["icon"], book["title"]]
	page_num_lbl.text = "%d / %d Oldal" % [current_page_idx + 1, book["pages"].size()]
	page_text_lbl.text = book["pages"][current_page_idx]
	
	btn_prev.disabled = (current_page_idx == 0)
	btn_next.disabled = (current_page_idx == book["pages"].size() - 1)
