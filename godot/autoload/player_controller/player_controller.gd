extends Node

signal character_control_swapped(selected_player: PlayerNames.Name)

## Designates how control should be split between the two characters.
enum ControlModes
{
	## Both characters are controlled with the same keys.
	## Player can swap which character is currently controlled
	SOLO,
	## Both characters are controlled with different keys,
	## allowing for local co-op
	COOP
}


## Designates how control should be split between the two characters.
@export var control_mode: ControlModes = ControlModes.SOLO

## Designates which character is currently controlled. This settings only matters in SOLO mode.
@export var currently_selected_character: PlayerNames.Name = PlayerNames.Art

## Whether or not a character should handle input controls
func can_move(character: PlayerNames.Name) -> bool:
	# The character can move always in co-op mode, or only if they are selected in solo mode
	return (!is_solo()) or currently_selected_character == character

func is_solo() -> bool:
	return control_mode == ControlModes.SOLO

# Idk if this should be _input or not.
func _unhandled_input(event: InputEvent) -> void:
	if is_solo() and event.is_action_pressed("swap_characters"):
		currently_selected_character = PlayerNames.invert_name(currently_selected_character)
		character_control_swapped.emit(currently_selected_character)
