extends Node2D


@onready var player: Control = $Player


var platform_preload: PackedScene = preload("res://Scenes/platform.tscn")
var platfrom_1: Platform
var platfrom_2: Platform


func _ready() -> void:
	start_game()


func start_game() -> void:
	platfrom_1 = null
	platfrom_2 = null
	platfrom_1 = platform_preload.instantiate()
	platfrom_2 = platform_preload.instantiate()
	

	add_child(platfrom_1)
	platfrom_1.position.x = 0
	add_child(platfrom_2)
	
	player.position.x = (platfrom_1.position.x + platfrom_1.get_size_x()) - 20


func move_player_to_platform() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(player, "position:x", platfrom_2.position.x + platfrom_2.get_size_x() - 20, 0.5)
	tween.finished.connect(spawn_next_platform)


func spawn_next_platform() -> void:
	var min_pos_x = platfrom_2.position.x + 200
	var max_pos_x = platfrom_2.position.x + 420
	platfrom_2 = platform_preload.instantiate()
	platfrom_2.min_position_x = min_pos_x
	platfrom_2.max_position_x = max_pos_x
	add_child(platfrom_2)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		move_player_to_platform()
