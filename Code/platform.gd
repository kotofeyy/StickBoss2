class_name Platform extends Control

@onready var center: ColorRect = $Center
@onready var main: ColorRect = $Main


func _ready() -> void:
	print("im there")
	random_position()
	random_size()
	center.position.x = (main.size.x - center.size.x) / 2
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "position:y", 640, 0.3)
	await get_tree().create_timer(1.0).timeout
	print("timeout")
	queue_free()


func random_position() -> void:
	position.x = randi_range(200, 420)


func random_size() -> void:
	main.size.x = randi_range(40, 90)


func _process(delta: float) -> void:
	pass
