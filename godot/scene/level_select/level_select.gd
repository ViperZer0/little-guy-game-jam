extends Control

@onready var level_grid: GridContainer = %LevelGrid

func _ready() -> void:
	for level in range(LevelManager.level_paths.size()):
		var button = create_button_for_level(level)
		level_grid.add_child(button)

func create_button_for_level(level: int) -> SFXButton:
	var button = SFXButton.new()
	button.text = str(level + 1)
	button.pressed.connect(func (): LevelManager.load_level(level))
	return button

func _on_back_button_pressed() -> void:
	SceneManager.switch_to_previous_scene()
