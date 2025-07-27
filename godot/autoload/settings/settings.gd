## This class stores and tracks the various settings
extends Node

## This signal is fired whenever a setting is changed
signal setting_changed(what: String, to: Variant)

## This signal is fired whenever animation flicker is enabled or disabled
signal animation_flicker_changed(enabled: bool)

@export var animation_flicker: bool = true:
	get:
		return animation_flicker
	set(value):
		if animation_flicker != value:
			animation_flicker = value
			animation_flicker_changed.emit(value)
			setting_changed.emit("animation_flicker", value)
