## This singleton manages loading and switching between scenes.
extends Node

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
## new scene after we instantiate it but before we load the new scene
func switch_scenes(node: Node) -> void:
	_defer_switch_scenes.call_deferred(node)

func _defer_switch_scenes(node: Node) -> void:
	# We can free bc we're calling this function deferred.
	current_scene.free()

	current_scene = node
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
