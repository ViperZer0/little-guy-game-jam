class_name Selector extends HBoxContainer

signal selected_option_changed(option: StringName)

@export var options: Array[StringName]

@onready var label: Label = %Label
var current_index := 0

func _ready():
	label.text = options[current_index]

func set_index(index: int) -> void:
	current_index = index % options.size()
	label.text = options[current_index]
	selected_option_changed.emit(options[current_index])

func _on_left_button_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		current_index = (current_index - 1) % options.size()
		label.text = options[current_index]
		selected_option_changed.emit(options[current_index])

func _on_right_button_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		current_index = (current_index + 1) % options.size()
		label.text = options[current_index]
		selected_option_changed.emit(options[current_index])
