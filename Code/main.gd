extends Node2D

var platform_preload: PackedScene = preload("res://Scenes/platform.tscn")



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("ui_accept")
		var platform: Platform = platform_preload.instantiate()
		add_child(platform)
