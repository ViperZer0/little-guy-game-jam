## AnimatedSprite2D that checks [class SettingsManager] to see whether we should be animated or not.
class_name ToggleAnimatedSprite2D extends AnimatedSprite2D

func _ready():
	if not SettingsManager.animation_flicker:
		stop()
	else:
		play()

	SettingsManager.animation_flicker_changed.connect(_on_animation_flicker_changed)

func _on_animation_flicker_changed(to: bool) -> void:
	if to:
		play()
	else:
		pause()
