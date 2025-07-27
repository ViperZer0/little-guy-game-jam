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

@onready var torso_sprite: AnimatedSprite2D = %PlayerTorso
@onready var head_sprite: AnimatedSprite2D = %PlayerBody
@onready var selection_arrow_sprite: Sprite2D = %SelectionArrow
@onready var selection_arrow_sprite_offset: float = selection_arrow_sprite.position.y
@onready var selection_arrow_timer: Timer = %SelectionArrowTimeout
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

	# Set torso color depending on who we're playing
	torso_sprite.modulate = Color("#54aaff") if player == PlayerNames.Art else Color("#ff7d79")

	if PlayerController.is_solo():
		if PlayerController.currently_selected_character == player:
			show_selection_arrow()
		else:
			selection_arrow_sprite.hide()

		PlayerController.character_control_swapped.connect(_on_character_control_swapped)


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
			push_error("Did not get a valid combination of inputs in _get_direction_name!!!")
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
			push_error("Did not get a valid combination of inputs in _get_jump_name!")
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
	if torso_sprite:
		torso_sprite.flip_v = upside_down

	if head_sprite:
		head_sprite.flip_v = upside_down

	# Flip arrow sprite
	if selection_arrow_sprite:
		selection_arrow_sprite.flip_v = upside_down
		selection_arrow_sprite.position.y = selection_arrow_sprite_offset * (-1 if upside_down else 1)

	# Change up direction
	up_direction = Vector2(0, 1 if upside_down else -1)

func _on_player_detector_body_entered(body: Node2D) -> void:
	# This should be a player, but we'll check just in case.
	if body is Player:
		players_collided.emit()

func _on_character_control_swapped(selected_player: PlayerNames.Name) -> void:
	if selected_player == player:
		show_selection_arrow()
	else:
		selection_arrow_sprite.hide()

func show_selection_arrow() -> void:
	selection_arrow_sprite.show()
	selection_arrow_timer.start()
	await selection_arrow_timer.timeout
	selection_arrow_sprite.hide()
