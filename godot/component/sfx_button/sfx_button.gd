class_name SFXButton extends Button

func _ready() -> void:
	button_down.connect(func (): ButtonSFXPlayer.play_click())
	button_up.connect(func (): ButtonSFXPlayer.play_release())
