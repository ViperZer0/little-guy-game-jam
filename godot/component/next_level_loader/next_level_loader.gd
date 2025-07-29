class_name NextLevelLoader extends Node

func _ready() -> void:
	LevelManager.queue_load_next_level()

func load_next_level() -> void:
	LevelManager.load_next_level()

