extends Control


@onready var mode_description_label: Label = %ModeDescription

func _on_solo_button_mouse_entered() -> void:
	mode_description_label.text = "One player controls both characters. Press Space to switch controls between each character"

func _on_coop_button_mouse_entered() -> void:
	mode_description_label.text = "Controls are split between both characters. One player controls one character with WASD, the other player controls the other character with the arrow keys"
