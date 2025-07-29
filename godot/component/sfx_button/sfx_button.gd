class_name SFXButton extends Button

@export var click_sfx: AudioStream = preload("res://component/sfx_button/click_press.ogg")
@export var release_sfx: AudioStream = preload("res://component/sfx_button/click_release.ogg")

@onready var click_player: AudioStreamPlayer = %ClickPlayer
@onready var release_player: AudioStreamPlayer = %ReleasePlayer

func _ready() -> void:
	if !click_player:
		click_player = AudioStreamPlayer.new()
		click_player.bus = "SFX"
		click_player.stream = click_sfx
		add_child(click_player)

	if !release_player:
		release_player = AudioStreamPlayer.new()
		release_player.bus = "SFX"
		release_player.stream = release_sfx
		add_child(release_player)

	button_down.connect(func (): click_player.play())
	button_up.connect(func (): release_player.play())
