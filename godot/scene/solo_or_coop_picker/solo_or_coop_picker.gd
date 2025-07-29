extends Control

@export_file("*.tscn") var next_scene_path: String

@onready var mode_description_label: Label = %ModeDescription

func _ready() -> void:
	SceneManager.queue_load_next_scene_path(next_scene_path)

func _switch_to_game() -> void:
	var packed_scene = SceneManager.load_next_scene_path(next_scene_path)
	var new_scene = packed_scene.instantiate()
	SceneManager.switch_scenes(new_scene)

func _on_solo_button_mouse_entered() -> void:
	mode_description_label.text = "One player controls both characters. Press Space to switch controls between each character"

func _on_solo_button_pressed() -> void:
	PlayerController.control_mode = PlayerController.ControlModes.SOLO
	_switch_to_game()

func _on_coop_button_mouse_entered() -> void:
	mode_description_label.text = "Controls are split between both characters. One player controls one character with WASD, the other player controls the other character with the arrow keys"

func _on_coop_button_pressed() -> void:
	PlayerController.control_mode = PlayerController.ControlModes.COOP
	_switch_to_game()

func _on_back_button_pressed() -> void:
	SceneManager.switch_to_previous_scene()
