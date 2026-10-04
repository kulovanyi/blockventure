extends Label

func show_text(txt: String, target_pos: Vector2, text_color: Color = Color(1.0, 0.85, 0.2)) -> void:
	text = txt
	modulate = text_color
	global_position = target_pos - Vector2(size.x * 0.5, 0)
	scale = Vector2(0.5, 0.5)
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "global_position:y", global_position.y - 45.0, 0.6)
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)
