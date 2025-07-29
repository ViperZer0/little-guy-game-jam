extends Node

## List of all the levels in the correct order.
@export var level_paths: Array[StringName]

var current_level: int = 0

## Triggers loading the next level but doesn't switch to it next.
func queue_load_level(level: int) -> void:
	var level_path = level_paths[level]
	if !level_path:
		push_warning("Attempted to load an invalid level number! Ignoring!")
		return

	SceneManager.queue_load_next_scene_path(level_path)

## Now we switch to the next level!
func load_level(level: int) -> void:
	var level_path = level_paths[level]
	if !level_path:
		push_warning("Attempted to load an invalid level number! Ignoring!")
		return

	# Apparently we DO have to call queue first... ig...
	SceneManager.queue_load_next_scene_path(level_path)
	var scene = SceneManager.load_next_scene_path(level_path)
	var node = scene.instantiate()
	current_level = level
	SceneManager.switch_scenes(node)

func queue_load_next_level() -> void:
	queue_load_level(current_level + 1)

func load_next_level() -> void:
	load_level(current_level + 1)
