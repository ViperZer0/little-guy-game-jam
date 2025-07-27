class_name TypewriterLabel extends Label

@export var letters_per_second: float = 10.0
var time_since_last_letter_shown: float = 0.0
var letters_shown: int = 0

var full_text: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	full_text = text
	if SettingsManager.animation_flicker:
		# If we're gonna animate the typewriter effect, clear the string so we can animate it coming back.
		text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not SettingsManager.animation_flicker:
		text = full_text
		return

	if text.length() == full_text.length():
		return

	time_since_last_letter_shown += delta

	if time_since_last_letter_shown > (1.0/letters_per_second):
		letters_shown += 1
		text = full_text.substr(0, letters_shown)
		time_since_last_letter_shown = 0.0

