## An AnimatedTexture that checks the settings to see whether or not to enable animation
class_name ToggleAnimatedTexture extends AnimatedTexture

func _init() -> void:
	ready.call_deferred()

func ready() -> void:
	# What the fuck
	var tree = Engine.get_main_loop() as SceneTree
	# Listen for nodes being added so we can handle when the Settings autoload is added
	tree.node_added.connect(_on_scene_tree_node_added)

func _on_scene_tree_node_added(node: Node) -> void:
	# All of this code potentially runs in the editor despite not being a tool script
	if not Engine.is_editor_hint() and node is SettingsManager:
		print(node)
		var settings: SettingsManager = node as SettingsManager
		print(settings)
		settings.animation_flicker_changed.connect(_on_animation_flicker_changed)
		pause = !settings.animation_flicker
		# Now we can unsubscribe and check tf out
		(Engine.get_main_loop() as SceneTree).node_added.disconnect(_on_scene_tree_node_added)

func _on_animation_flicker_changed(to: bool) -> void:
	pause = !to
