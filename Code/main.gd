extends Node2D


@onready var player: Control = $Player
@onready var animated_sprite_2d: AnimatedSprite2D = $Player/AnimatedSprite2D

@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var stick: ColorRect = $Stick
@onready var animated_sprite_bonus: AnimatedSprite2D = $AnimatedSpriteBonus

@onready var audio_stream_player_hit: AudioStreamPlayer = $AudioStreamPlayerHit
@onready var audio_stream_player_swipe: AudioStreamPlayer = $AudioStreamPlayerSwipe
@onready var audio_stream_player_defeat: AudioStreamPlayer = $AudioStreamPlayerDefeat
@onready var audio_stream_player_score_x: AudioStreamPlayer = $AudioStreamPlayerScoreX

@onready var start_game_button: Button = $CanvasLayer/StartGameButton
@onready var end_game_panel: Panel = $CanvasLayer/EndGamePanel

@onready var label_score: Label = $CanvasLayer/LabelScore
@onready var label_x: Label = $CanvasLayer/LabelScore/LabelX
@onready var result_score_label: RichTextLabel = $CanvasLayer/EndGamePanel/MarginContainer/VBoxContainer/ResultScoreLabel
@onready var best_score_label: RichTextLabel = $CanvasLayer/EndGamePanel/MarginContainer/VBoxContainer/BestScoreLabel
@onready var x_bonus_label: Label = $XBonusLabel
@onready var label_all_scores: Label = $CanvasLayer/HBoxContainer/LabelAllScores

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var parallax_background_2: ParallaxBackground = $ParallaxBackground2

@onready var v_box_container: VBoxContainer = $CanvasLayer/ShopPanel/MarginContainer/VScrollBar/VBoxContainer
@onready var shop_panel: Panel = $CanvasLayer/ShopPanel
@onready var shop_button_panel: Panel = $CanvasLayer/Panel
@onready var icon: AnimatedSprite2D = $CanvasLayer/Panel/ShopButton/Control/Icon





@onready var slot_preload: PackedScene = preload("res://Scenes/slot.tscn")
@onready var platform_preload: PackedScene = preload("res://Scenes/platform.tscn")
var platfrom_1: Platform
var platfrom_2: Platform
var center_platform_size_y := 6
var score := 0
var all_scores := 0
var game_is_starting := false
var temp_stick_position
var current_hit: String
var hit_center_counter := 1
var tween_label_score: Tween
var current_skin = Skins.Type.NINJA
var current_dashed_line_length = 0


func _ready() -> void:
	for s in Skins.List:
		var slot: Slot = slot_preload.instantiate()
		slot.description = Skins.List[s]["description"]
		slot.skin = s
		slot.cost = Skins.List[s]["cost"]
		slot.type_cost = Skins.List[s]["type_cost"]
		slot.player_score = all_scores
		slot.on_click.connect(func(skin): 
			slot.select(skin)
			shop_panel.visible = false
			current_skin = skin
			animated_sprite_2d.animation = str(skin)
			icon.animation = str(skin)
			)
		v_box_container.add_child(slot)
		slot.select(current_skin)
	animated_sprite_2d.animation = str(current_skin)
	icon.animation = str(current_skin)
	


func _physics_process(_delta: float) -> void:
	if game_is_starting:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("mouse_action") or Input.emulate_touch_from_mouse:
			stick.size.y += 3
			queue_redraw()

		if Input.is_action_just_released("ui_up") or Input.is_action_just_released("mouse_action"):
			rotate_stick()


func _draw() -> void:
	if stick.size.y > 20:
		var start_point = Vector2(stick.position.x, stick.position.y)
		var end_point = start_point + Vector2.RIGHT * Vector2(stick.size.y, platfrom_2.position.y)
		draw_dashed_line(start_point, end_point , Color.BLUE, 10, 10)


func start_game() -> void:
	clear_platforms()
	parallax_background.visible = false
	parallax_background_2.visible = false
	score = 0
	hit_center_counter = 1
	label_score.text = str(score)
	start_game_button.visible = false
	player.visible = true
	stick.visible = true
	label_x.visible = false
	shop_button_panel.visible = false
	
	match (randi_range(1,2)):
		1: parallax_background.visible = true
		2: parallax_background_2.visible = true
	
	platfrom_1 = platform_preload.instantiate()
	platfrom_2 = platform_preload.instantiate()
	
	add_child(platfrom_1)
	platfrom_1.position.x = 0
	platfrom_1.hide_center()
	add_child(platfrom_2)
	
	player.position.x = (platfrom_1.position.x + platfrom_1.get_size_x()) - 20
	stick.position.x = (platfrom_1.position.x + platfrom_1.get_size_x() - stick.size.x / 2)
	temp_stick_position = (platfrom_1.position.y - platfrom_1.get_size_y() + center_platform_size_y + stick.size.y)
	stick.position.y = temp_stick_position


func move_player_to_platform() -> void:
	score += 1
	label_score.text = str(score)
	animated_sprite_2d.play(str(current_skin))
	var tween = get_tree().create_tween()
	tween.tween_property(player, "position:x", platfrom_2.position.x + platfrom_2.get_size_x() - 20, 0.5)
	tween.finished.connect(spawn_next_platform)


func spawn_next_platform() -> void:
	animated_sprite_2d.pause()
	reset_stick()
	var min_pos_x = platfrom_2.position.x + 200
	var max_pos_x = platfrom_2.position.x + 420
	platfrom_2 = platform_preload.instantiate()
	platfrom_2.min_position_x = min_pos_x
	platfrom_2.max_position_x = max_pos_x
	add_child(platfrom_2)


func clear_platforms() -> void:
	var childs = get_children()
	for child in childs:
		if child is Platform:
			child.queue_free()


func label_score_shake() -> void:
	label_score.pivot_offset = Vector2(label_score.size.x / 2, label_score.size.y / 2)
	var tween = get_tree().create_tween() 
	tween.set_parallel(true)
	
	tween.tween_property(label_score, "scale", Vector2(1.5, 1.5), 0.1)
	tween.chain().tween_property(label_score, "scale", Vector2(1.0, 1.0), 0.1)
	
	tween.tween_property(label_score, "rotation_degrees", randi_range(-15, 15), 0.1)
	tween.chain().tween_property(label_score, "rotation_degrees", 0, 0.1)


func animate_label_x(start_val: int, end_val: int, duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(label_score, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_method(_set_label_number, start_val, end_val, duration)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	tween.finished.connect(func(): label_score.scale = Vector2(1.0, 1.0))


func _set_label_number(value: int):
	label_score.text = str(value)


func rotate_stick() -> void:
	audio_stream_player_swipe.play()
	stick.size.x = stick.size.x / 2
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(stick, "rotation_degrees", 180 + 90, 0.3)
	if check_distance() == "hit":
		tween.finished.connect(move_player_to_platform)
		current_hit = "hit"
		label_x.visible = false
		label_x.text = ""
		if hit_center_counter > 1:
			var start_value = score
			score *= hit_center_counter
			audio_stream_player_score_x.play()
			animate_label_x(start_value, score)
		hit_center_counter = 1

	elif check_distance() == "hit_center":
		tween.finished.connect(func(): 
			move_player_to_platform()
			hit_to_center()
			)
	else:
		game_is_starting = false
		tween.finished.connect(stick_defeat)


func hit_to_center() -> void:
	all_scores += 1
	label_all_scores.text = str(all_scores)
	camera_2d.applay_shake()
	label_score_shake()
	x_bonus_label.position.y = platfrom_2.position.y
	x_bonus_label.position.x = platfrom_2.position.x + randi_range(10, 50)
	x_bonus_label.modulate.a = 1.0
	x_bonus_label.text = ["ВАУ!", "Круто!", "Класс!", "Великолепно!", "Превосходно!"].pick_random()
		
	var tween_x_bonus = get_tree().create_tween()
	tween_x_bonus.set_parallel(true)
	tween_x_bonus.tween_property(x_bonus_label, "position:y", platfrom_2.get_size_y() - 10, 1.0)
	tween_x_bonus.tween_property(x_bonus_label, "modulate:a", 0, 1.0)
	
	if current_hit == "center":
		hit_center_counter += 1
		label_x.visible = true
		label_x.text = "x" + str(hit_center_counter)

	platfrom_2.hit_to_center()
	spawn_bonus_effect()
	audio_stream_player_hit.play()
	current_hit = "center"


func stick_defeat() -> void:
	audio_stream_player_defeat.play()
	camera_2d.camera_zoom_defeat()
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(stick, "size", Vector2(15.0, 20.0), 0.3)
	tween.finished.connect(func(): 
		end_game_panel.visible = true
		result_score_label.text = "Очки: " + str(score)
		best_score_label.text = "Рекорд: " + str(score)
		stick.rotation_degrees = 180
		platfrom_2.defeat()
		stick.visible = false
		)


func reset_stick() -> void:
	stick.size.x = 15
	stick.size.y = 20
	stick.position.x = (platfrom_2.position.x + platfrom_2.get_size_x() - stick.size.x / 2)
	stick.position.y = temp_stick_position
	
	stick.rotation_degrees = 180
	queue_redraw()


func check_distance() -> String:
	var distance_min = abs(stick.position.x - platfrom_2.position.x)
	var distance_max = (distance_min - stick.size.x) + platfrom_2.get_size_x()
	var center_position_platform = distance_min + platfrom_2.get_size_x() / 2 
	var distance_min_center = abs(center_position_platform - (platfrom_2.get_size_x_center() / 2))
	var distance_max_center = distance_min_center + platfrom_2.get_size_x_center()
	
	if stick.size.y >= distance_min and stick.size.y <= distance_max:
		if stick.size.y >= distance_min_center and stick.size.y <= distance_max_center:
			return "hit_center"
		return "hit"
	else:
		return "miss"


func spawn_bonus_effect() -> void:
	var pos_x = platfrom_2.position.x + platfrom_2.get_size_x() / 2
	var pos_y = stick.position.y
	animated_sprite_bonus.position.x = pos_x
	animated_sprite_bonus.position.y = pos_y
	
	animated_sprite_bonus.play("action")


func _on_start_game_button_pressed() -> void:
	start_game()
	await get_tree().create_timer(0.5).timeout
	game_is_starting = true


func _on_reset_game_button_pressed() -> void:
	camera_2d.camera_zoom_start_game()
	end_game_panel.visible = false
	start_game()
	await get_tree().create_timer(0.5).timeout
	game_is_starting = true


func _on_cancel_button_pressed() -> void:
	player.visible = false
	clear_platforms()
	camera_2d.camera_zoom_start_game()
	end_game_panel.visible = false
	await get_tree().create_timer(0.5).timeout
	start_game_button.visible = true
	shop_button_panel.visible = true
	

func _on_shop_button_pressed() -> void:
	shop_panel.visible = true
	set_current_selected()


func set_current_selected() -> void:
	var childs = v_box_container.get_children()
	
	for child: Slot in childs:
		child.select(current_skin)
