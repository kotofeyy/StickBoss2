extends Panel
class_name Slot

@onready var sprite: AnimatedSprite2D = $HBoxContainer/Control/Sprite
@onready var default_slot: StyleBoxFlat  = preload("res://themes/default_slot.tres")
@onready var selected_slot: StyleBoxFlat = preload("res://themes/selected_slot.tres")
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel

@export var description: String
var skin: Skins.Type

signal on_click


func _ready() -> void:
	sprite.animation = str(skin)
	rich_text_label.text = description
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_pressed("mouse_action"):
		emit_signal("on_click", skin)


func select(s: Skins.Type) -> void:
	if selected_slot:
		if s == skin:
			add_theme_stylebox_override("panel", selected_slot)
			grab_focus()


func _clear_select() -> void:
	add_theme_stylebox_override("panel", default_slot)


func _on_focus_exited() -> void:
	_clear_select()
