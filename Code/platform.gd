class_name Platform extends Control

@onready var center: ColorRect = $Center
@onready var main: ColorRect = $Main
@onready var base_platfrom: TextureRect = $BasePlatfrom


var min_position_x = 200
var max_position_x = 420

var can_remove: bool = false


func _ready() -> void:
	random_position()
	random_size()
	center.position.x = (base_platfrom.size.x - center.size.x) / 2
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "position:y", 640, 0.5)
	tween.finished.connect(func(): 
		can_remove = true
	)


func random_position() -> void:
	position.x = randi_range(min_position_x, max_position_x)


func random_size() -> void:
	if base_platfrom:
		base_platfrom.size.x = randi_range(40, 90)


func get_size_x() -> int:
	return base_platfrom.size.x


func get_size_y() -> int:
	return base_platfrom.size.y


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if can_remove:
		queue_free()
