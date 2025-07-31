extends AnimatableBody2D

## How fast the spinner should spin in degrees per second
@export var spin_rate: float = 10.0

func _process(delta: float) -> void:
	rotate(deg_to_rad(spin_rate) * delta)
