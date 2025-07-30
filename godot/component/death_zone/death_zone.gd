class_name DeathZone extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Restart the level if a player touches this zone
		print("AWWARAWRAWR")
		LevelManager.restart_level()
