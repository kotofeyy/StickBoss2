extends Panel
class_name Slot

@onready var sprite: AnimatedSprite2D = $MarginContainer/HBoxContainer/Control/Sprite
@onready var default_slot: StyleBoxFlat  = preload("res://themes/default_slot.tres")
@onready var selected_slot: StyleBoxFlat = preload("res://themes/selected_slot.tres")
@onready var label_cost: Label = $MarginContainer/HBoxContainer/LabelCost


@export var description: String
var skin: Skins.Type
var cost: int
var coins
var type_cost: Skins.TypeCost
var available := false

signal on_click


func _ready() -> void:
	sprite.animation = str(skin)
	if not available:
		if type_cost == Skins.TypeCost.COIN:
			label_cost.text = str(coins) + "/" + str(cost) + " " + tr("KEY_COIN")
		if type_cost == Skins.TypeCost.SCORE:
			label_cost.text = str(cost) + " " + tr("KEY_SCORE")
	else:
		label_cost.text = tr("KEY_AVAILABLE")


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Input.is_action_pressed("mouse_action"):
		var can_buy = coins >= cost
		emit_signal("on_click", skin, can_buy)


func select(s: Skins.Type) -> void:
	if not available:
		focus_mode = Control.FOCUS_NONE
	else:
		if selected_slot:
			if s == skin:
				add_theme_stylebox_override("panel", selected_slot)
				grab_focus()


func _clear_select() -> void:
	add_theme_stylebox_override("panel", default_slot)


func _on_focus_exited() -> void:
	_clear_select()
