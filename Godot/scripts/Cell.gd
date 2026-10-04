extends Control

var row: int = 0
var col: int = 0
var is_filled: bool = false
var color_name: String = ""
var is_preview: bool = false
var is_will_clear: bool = false

func _ready() -> void:
	custom_minimum_size = Vector2(52, 52)

func init_cell(r: int, c: int) -> void:
	row = r
	col = c
	queue_redraw()

func set_filled(col_name: String) -> void:
	is_filled = true
	color_name = col_name
	is_preview = false
	is_will_clear = false
	scale = Vector2.ONE
	modulate = Color.WHITE
	queue_redraw()

func clear_cell() -> void:
	is_filled = false
	color_name = ""
	is_preview = false
	is_will_clear = false
	scale = Vector2.ONE
	modulate = Color.WHITE
	queue_redraw()

func set_preview(preview: bool) -> void:
	if is_filled: return
	if is_preview != preview:
		is_preview = preview
		queue_redraw()

func set_will_clear(will_clear: bool) -> void:
	if not is_filled: return
	if is_will_clear != will_clear:
		is_will_clear = will_clear
		queue_redraw()

func play_clear_animation() -> void:
	var tw = create_tween()
	tw.tween_property(self, "scale", Vector2(1.2, 1.2), 0.08)
	tw.parallel().tween_property(self, "modulate", Color(2.5, 2.5, 2.5, 1.0), 0.08)
	tw.tween_property(self, "scale", Vector2.ZERO, 0.12)
	tw.tween_callback(func():
		clear_cell()
	)

func _draw() -> void:
	var rect = Rect2(Vector2.ZERO, size)
	var radius = 6.0
	
	if is_filled:
		var c: Color = GameManager.COLORS.get(color_name, Color(0.2, 0.5, 0.9))
		if is_will_clear:
			c = c.lightened(0.4)
			
		# Main filled block
		draw_rect(rect, c, true, -1.0)
		
		# Top/Left subtle 3D bevel shine
		var shine_rect = Rect2(Vector2(2, 2), Vector2(size.x - 4, (size.y - 4) * 0.45))
		draw_rect(shine_rect, Color(1, 1, 1, 0.22), true, -1.0)
		
		# Block border
		draw_rect(rect, Color(1, 1, 1, 0.3), false, 1.0)
	elif is_preview:
		# Placement preview
		draw_rect(rect, Color(1, 1, 1, 0.25), true, -1.0)
		draw_rect(rect, Color(1, 1, 1, 0.5), false, 1.5)
	else:
		# Empty grid slot
		draw_rect(rect, Color(1, 1, 1, 0.04), true, -1.0)
		draw_rect(rect, Color(1, 1, 1, 0.08), false, 1.0)
