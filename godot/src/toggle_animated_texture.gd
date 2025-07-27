## An AnimatedTexture that checks the settings to see whether or not to enable animation
class_name ToggleAnimatedTexture extends AnimatedTexture

func _init() -> void:
	ready.call_deferred()

func ready() -> void:
	# What the fuck
	var tree = Engine.get_main_loop() as SceneTree
	var settings: Settings = tree.root.get_node("/root/Settings") as Settings
	settings.animation_flicker_changed.connect(_on_animation_flicker_changed)
	pause = !settings.animation_flicker

func _on_animation_flicker_changed(to: bool) -> void:
	pause = !to
