extends Node

@onready var click_player: AudioStreamPlayer = $ClickPlayer
@onready var release_player: AudioStreamPlayer = $ReleasePlayer

func play_click() -> void:
	click_player.play()

func play_release() -> void:
	release_player.play()
