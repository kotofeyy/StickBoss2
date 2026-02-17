extends Camera2D


func applay_shake() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "zoom", Vector2(1.1, 1.1), 0.1)
	tween.chain().tween_property(self, "zoom", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(self, "rotation_degrees", randi_range(-15, 15), 0.1)
	tween.chain().tween_property(self, "rotation_degrees", 0, 0.1)


func camera_zoom_defeat() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1.5, 1.5), 1.0)


func camera_zoom_start_game() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), 0.5)
