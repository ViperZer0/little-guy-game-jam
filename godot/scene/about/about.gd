extends Control

func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))

func _on_button_pressed() -> void:
	SceneManager.switch_to_previous_scene()

