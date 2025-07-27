## This class stores and tracks the various settings
extends Node

## This signal is fired whenever a setting is changed
signal setting_changed(what: String, to: Variant)

## This signal is fired whenever animation flicker is enabled or disabled
signal animation_flicker_changed(enabled: bool)

signal upside_down_horizontal_controls_relative_to_player_changed(enabled: bool)
signal upside_down_vertical_controls_relative_to_player_changed(enabled: bool)

@export var animation_flicker: bool = true:
	get:
		return animation_flicker
	set(value):
		if animation_flicker != value:
			animation_flicker = value
			animation_flicker_changed.emit(value)
			setting_changed.emit("animation_flicker", value)

## This setting controls whether or not the upside down player's controls
## are relative to the PLAYER (true) or the SCREEN (false).
##
## When the player's controls are relative to the screen, left moves the player left on the screen even though
## they are upside down. When the player's controls are relative to the player, moving left moves the player right, since they are upside down.
@export var upside_down_horizontal_controls_relative_to_player: bool = false:
	get:
		return upside_down_horizontal_controls_relative_to_player
	set(value):
		if upside_down_horizontal_controls_relative_to_player != value:
			upside_down_horizontal_controls_relative_to_player = value
			upside_down_horizontal_controls_relative_to_player_changed.emit(value)
			setting_changed.emit("upside_down_horizontal_controls_relative_to_player", value)

## This setting controls whether or not the upside down player's controls
## are relative to the PLAYER (true) or the SCREEN (false).
##
## When the player's controls are relative to the screen, pressing up will always make the character jump,
## even if they are upside down. When the player's controls are relative to the player, pressing down will make the character jump when they are upside down, since they are jumping downwards.
@export var upside_down_vertical_controls_relative_to_player: bool = false:
	get:
		return upside_down_vertical_controls_relative_to_player
	set(value):
		if upside_down_vertical_controls_relative_to_player != value:
			upside_down_vertical_controls_relative_to_player = value
			upside_down_vertical_controls_relative_to_player_changed.emit(value)
			setting_changed.emit("upside_down_vertical_controls_relative_to_player", value)

