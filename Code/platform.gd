class_name Platform extends Control

@onready var control_center: Control = $ControlCenter
@onready var base_platfrom: TextureRect = $BasePlatfrom


var min_position_x = 200
var max_position_x = 420

var can_remove: bool = false


func _ready() -> void:
	_random_position()
	_random_size()
	
	control_center.position.x = (base_platfrom.size.x - control_center.size.x) / 2
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:y", 640, 0.5)
	tween.finished.connect(func(): 
		can_remove = true
	)


func _random_position() -> void:
	position.x = randi_range(min_position_x, max_position_x)


func _random_size() -> void:
	if base_platfrom:
		base_platfrom.size.x = randi_range(40, 90)


func get_size_x() -> float:
	return base_platfrom.size.x


func get_size_y() -> float:
	return base_platfrom.size.y


func get_size_x_center() -> float:
	return control_center.size.x


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if can_remove:
		queue_free()


func hit_to_center() -> void:
	control_center.position.y = 50


func defeat() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position:y", 900, 0.5)


func hide_center() -> void:
	control_center.visible = false
