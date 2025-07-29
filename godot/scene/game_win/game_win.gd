extends Node2D

@export_file("*.tscn") var title_scene_path: String

func _ready() -> void:
	SceneManager.queue_load_next_scene_path(title_scene_path)

func _on_button_pressed() -> void:
	var scene = SceneManager.load_next_scene_path(title_scene_path)
	var node = scene.instantiate()
	SceneManager.switch_scenes(node)
	SceneManager.clear_scene_stack()
