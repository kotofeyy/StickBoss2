extends Node2D


@onready var player: Control = $Player
@onready var animated_sprite_2d: AnimatedSprite2D = $Player/AnimatedSprite2D
@onready var stick: ColorRect = $Stick

@onready var label_score: Label = $CanvasLayer/Label
@onready var animated_sprite_fire: AnimatedSprite2D = $CanvasLayer/Label/AnimatedSpriteFire

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var parallax_background_2: ParallaxBackground = $ParallaxBackground2


var platform_preload: PackedScene = preload("res://Scenes/platform.tscn")
var platfrom_1: Platform
var platfrom_2: Platform
var score := 0
var is_building := false
var temp_stick_position


func _ready() -> void:
	start_game()
	#start_burning_label()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("mouse_action") or Input.emulate_touch_from_mouse:
		stick.scale.y += 0.2
		is_building = true
		print("нажимаююю")

	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("mouse_action"):
		rotate_stick()


func start_game() -> void:
	platfrom_1 = null
	platfrom_2 = null
	parallax_background.visible = false
	parallax_background_2.visible = false
	score = 0
	label_score.text = str(score)
	animated_sprite_fire.visible = false
	
	match (randi_range(1,2)):
		1: parallax_background.visible = true
		2: parallax_background_2.visible = true
	
	platfrom_1 = platform_preload.instantiate()
	platfrom_2 = platform_preload.instantiate()
	

	add_child(platfrom_1)
	platfrom_1.position.x = 0
	add_child(platfrom_2)
	
	player.position.x = (platfrom_1.position.x + platfrom_1.get_size_x()) - 20
	stick.position.x = platfrom_1.position.x + platfrom_1.get_size_x()
	temp_stick_position = platfrom_1.position.y - platfrom_1.get_size_y()
	stick.position.y = temp_stick_position


func move_player_to_platform() -> void:
	animated_sprite_2d.play("walk")
	var tween = get_tree().create_tween()
	tween.tween_property(player, "position:x", platfrom_2.position.x + platfrom_2.get_size_x() - 20, 0.5)
	tween.finished.connect(spawn_next_platform)


func spawn_next_platform() -> void:
	animated_sprite_2d.pause()
	score += 1
	label_score.text = str(score)
	reset_stick()
	
	var min_pos_x = platfrom_2.position.x + 200
	var max_pos_x = platfrom_2.position.x + 420
	platfrom_2 = platform_preload.instantiate()
	platfrom_2.min_position_x = min_pos_x
	platfrom_2.max_position_x = max_pos_x
	add_child(platfrom_2)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		move_player_to_platform()


func start_burning_label() -> void:
	animated_sprite_fire.visible = true
	var tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(label_score, "modulate", Color.YELLOW, 0.3)
	tween.chain().tween_property(label_score, "modulate", Color.WHITE, 0.3)


func rotate_stick() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(stick, "rotation_degrees", 90, 0.3)
	tween.finished.connect(move_player_to_platform)


func reset_stick() -> void:
	stick.position.x = platfrom_2.position.x + platfrom_2.get_size_x()
	stick.position.y = temp_stick_position
	stick.scale.y = 1
	stick.rotation = 0
