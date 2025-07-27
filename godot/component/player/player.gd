class_name Player extends CharacterBody2D

enum Direction {
	LEFT,
	RIGHT
}

@export var player: PlayerNames.Name = PlayerNames.Art

@export var upside_down: bool = false:
	get:
		return upside_down
	set(value):
		upside_down = value
		_set_upside_down(value)

@onready var player_sprite: Sprite2D = %PlayerSprite
@onready var player_detector: Area2D = %PlayerDetector

## This signal is fired when the two players touched!
signal players_collided()

var gravity: float
var move_speed: float = 20000.0
var jump_velocity: float = 400.0

func _ready() -> void:
	# Set collisions/detections between players
	match player:
		PlayerNames.Art:
			set_collision_layer_value(2, true)
			player_detector.set_collision_mask_value(3, true)
			set_collision_layer_value(3, false)
			player_detector.set_collision_mask_value(2, false)
		PlayerNames.Mike:
			set_collision_layer_value(3, true)
			player_detector.set_collision_mask_value(2, true)
			set_collision_layer_value(2, false)
			player_detector.set_collision_mask_value(3, false)

	# Force initialization of correct gravity and sprite direction and stuff
	_set_upside_down(upside_down)

func _physics_process(delta: float) -> void:
	# Move player according to gravity
	velocity.y += gravity * delta

	# Handle jump
	if _is_input_just_pressed(_get_jump_name()) and is_on_floor():
		velocity.y = jump_velocity * (1 if upside_down else -1)

	# Move side to side
	velocity.x = (_get_action_strength(_get_direction_name(Direction.RIGHT)) - _get_action_strength(_get_direction_name(Direction.LEFT))) * delta * move_speed

	move_and_slide()

func _get_direction_name(direction: Direction) -> StringName:
	match [upside_down, SettingsManager.upside_down_horizontal_controls_relative_to_player, direction]:
		# Rightside up player always has normal controls
		[false, _, Direction.LEFT]:
			return "move_left"
		[false, _, Direction.RIGHT]:
			return "move_right"
		# Upside down player may have inverted controls
		[true, false, Direction.LEFT]:
			return "move_left"
		[true, false, Direction.RIGHT]:
			return "move_right"
		[true, true, Direction.LEFT]:
			return "move_right"
		[true, true, Direction.RIGHT]:
			return "move_left"
		_:
			printerr("Did not get a valid combination of inputs in _get_direction_name!!!")
			return ""

func _get_jump_name() -> StringName:
	match [upside_down, SettingsManager.upside_down_vertical_controls_relative_to_player]:
		[false, _]:
			return "move_jump"
		[true, false]:
			return "move_jump"
		[true, true]:
			return "move_down"
		_:
			printerr("Did not get a valid combination of inputs in _get_jump_name!")
			return ""

func _get_action_strength(action_name: StringName) -> float:
	if PlayerController.can_move(player):
		# If we're solo, merge Art and Mike controls (return the max of the two strengths
		if PlayerController.is_solo():
			return max(Input.get_action_strength(_get_input_name_for_character(PlayerNames.Art, action_name)), Input.get_action_strength(_get_input_name_for_character(PlayerNames.Mike, action_name)))
		# Otherwise we only check our set of controls
		else:
			return Input.get_action_strength(_get_input_name_for_character(player, action_name))

	else:
		# No movement
		return 0.0

func _is_input_just_pressed(action_name: StringName) -> bool:
	if PlayerController.can_move(player):
		if PlayerController.is_solo():
			return Input.is_action_just_pressed(_get_input_name_for_character(PlayerNames.Art, action_name)) or Input.is_action_just_pressed(_get_input_name_for_character(PlayerNames.Mike, action_name))
		else:
			return Input.is_action_just_pressed(_get_input_name_for_character(player, action_name))

	else:
		return false

func _get_input_name_for_character(character: PlayerNames.Name, action_name: StringName) -> StringName:
	return str(PlayerNames.Name.keys()[character]).to_lower() + "_" + action_name

func _set_upside_down(upside_down: bool) -> void:
	# Flip gravity if needed.
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * (-1 if upside_down else 1)
	# Flip sprite
	if player_sprite:
		player_sprite.flip_v = upside_down

	# Change up direction
	up_direction = Vector2(0, 1 if upside_down else -1)

func _on_player_detector_body_entered(body: Node2D) -> void:
	# This should be a player, but we'll check just in case.
	if body is Player:
		players_collided.emit()
