class_name SFXButton extends Button

@onready var click_player: AudioStreamPlayer = %ClickPlayer
@onready var release_player: AudioStreamPlayer = %ReleasePlayer

func _ready() -> void:
	button_down.connect(func (): click_player.play())
	button_up.connect(func (): release_player.play())


