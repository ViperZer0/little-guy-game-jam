extends Node2D

@onready var arrow_instruction_label: TypewriterLabel = %ArrowInstructions
@onready var space_instruction_label: TypewriterLabel = %SpaceInstructions

func _ready():
	if PlayerController.is_solo():
		arrow_instruction_label.hide()
		space_instruction_label.show()
	else:
		arrow_instruction_label.show()
		space_instruction_label.hide()

