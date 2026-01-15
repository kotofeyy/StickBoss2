extends Camera2D


func applay_shake() -> void:
	var tween = get_tree().create_tween()
	#tween.tween_property(self, "position:y", initial_position.y - 1.1, 0.3)
	#tween.tween_property(self, "position:y", initial_position.y + 1.1, 0.3)
	tween.tween_property(self, "rotation_degrees", randi_range(25,-25), randf_range(0.2,0.4))

func camera_zoom_defeat() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1.5, 1.5), 0.5)


func camera_zoom_start_game() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), 0.5)
