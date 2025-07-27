extends Node2D

@onready var label: Label = %Label

func _on_click_sprite(_viewport: Node, _event: InputEvent, _shape_idx: int):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		label.visible = !label.visible
		pass
	pass