class_name Player extends CharacterBody2D

@export var player: PlayerNames.Name = PlayerNames.Art

@export var upside_down: bool = false:
	get:
		return upside_down
	set(value):
		upside_down = value
		_set_upside_down(value)

@onready var player_sprite: Sprite2D = %PlayerSprite

var gravity: float

func _ready() -> void:
	# Force initialization of correct gravity and sprite direction and stuff
	_set_upside_down(upside_down)

func _physics_process(delta: float) -> void:
	# Move player according to gravity
	velocity.y += gravity * delta

	move_and_slide()

func _set_upside_down(upside_down: bool) -> void:
	# Flip gravity if needed.
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * (-1 if upside_down else 1)
	# Flip sprite
	if player_sprite:
		player_sprite.flip_v = upside_down
