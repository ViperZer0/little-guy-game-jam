extends Control

@export_file("*.tscn") var next_scene_path: String

func _ready() -> void:
	SceneManager.queue_load_next_scene_path(next_scene_path)

func _load_main_scene() -> void:
	var scene = SceneManager.load_next_scene_path(next_scene_path)
	var node = scene.instantiate()
	SceneManager.switch_scenes(node)

func _on_yes_button_pressed() -> void:
	SettingsManager.animation_flicker = false
	_load_main_scene()

func _on_no_button_pressed() -> void:
	SettingsManager.animation_flicker = true
	_load_main_scene()
