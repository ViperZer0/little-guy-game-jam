## This singleton manages loading and switching between scenes.
extends Node


# Array of old scenes as PackedScenes??
var scene_stack: Array[PackedScene]
var current_scene: Node

func _ready() -> void:
	# Gets the LAST loaded scene which is guaranteed to be the only non-autoloaded scene. I think.
	current_scene = get_tree().root.get_child(-1)

## Loads a new scene from a path and returns the new PackedScene
## With it as soon as possible (blocks). After the scene has been loaded, instantiate it and then pass it to [method switch_scenes]
## To actually load the new scene in
##
## You can call [method queue_load_next_scene_path] to asynchronously load the next scene
## Before it's needed
func load_next_scene_path(path: String) -> PackedScene:
	return ResourceLoader.load_threaded_get(path)

## Asynchronously loads a scene/resource/path. Call [method load_next_scene_path] to get the
## loaded scene.
func queue_load_next_scene_path(path: String) -> void:
	ResourceLoader.load_threaded_request(path)

## Switch to the new scene. We don't use a path here bc we want to be able to set up the
## new scene after we instantiate it but before we load the new scene.
##
## We also leave the old current_scene loaded, we just remove it from the scene tree.
## We can go back to it with [method switch_to_previous_scene]
func switch_scenes(node: Node) -> void:
	var packed_scene = PackedScene.new()
	packed_scene.pack(current_scene)
	scene_stack.push_back(packed_scene)
	_switch_scenes_deferred.call_deferred(node, false)

## Unloads the current scene (and DOES delete it), and goes back to the previous scene before this one.
func switch_to_previous_scene() -> void:
	# Get the new end of the scene stack
	var previous_scene = scene_stack.pop_back()
	if !previous_scene:
		push_warning("No previous scene to go back to. Ignoring")
		return

	var previous_scene_node = previous_scene.instantiate()
	_switch_scenes_deferred.call_deferred(previous_scene_node, true)

## Clears the contents of the scene stack, unloads all scenes except the current one.
func clear_scene_stack() -> void:
	# We don't free the scenes. We just forget about them and wait for GC to delet them.
	# for scene in scene_stack:
	#	scene.free()

	scene_stack.clear()

# This function does NOT manipulate the scene_stack, you gotta do that on your own. :]
func _switch_scenes_deferred(to: Node, delete_old_scene: bool) -> void:
	if delete_old_scene:
		# We can free bc we're calling this function deferred.
		current_scene.free()
	else:
		# Otherwise we just remove it from the scenetree.
		get_tree().root.remove_child(current_scene)

	current_scene = to
	get_tree().root.add_child(to)
	get_tree().current_scene = to
