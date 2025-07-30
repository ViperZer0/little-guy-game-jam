class_name Platform extends AnimatableBody2D

## The path to follow
@export var path: Path2D

## How long it takes to get from the beginning of the path to the end.
@export var path_duration: float = 2.0

var path_follow: PathFollow2D

func _ready() -> void:
	path_follow = PathFollow2D.new()
	path.add_child(path_follow)
	path_follow.progress_ratio = 0.0
	path_follow.loop = true

func _physics_process(delta: float) -> void:
	path_follow.progress_ratio += 1.0/path_duration * delta
	position = path_follow.position
