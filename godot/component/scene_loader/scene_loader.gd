## Simple helper component to make switching scenes easier.
## This won't work if there's logic/parameters that need to be initialized from the new scene.
class_name SceneLoader extends Node

@export var scene_path: StringName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.queue_load_next_scene_path(scene_path)

func switch_to_scene() -> void:
	var packed_scene = SceneManager.load_next_scene_path(scene_path)
	var scene_node = packed_scene.instantiate()
	SceneManager.switch_scenes(scene_node)
