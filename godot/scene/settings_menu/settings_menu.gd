extends Control

@onready var description: Label = %Description
@onready var enable_animation_selector: Selector = %EnableAnimationSelector
@onready var flip_horiz_selector: Selector = %FlipHorizSelector
@onready var flip_vert_selector: Selector = %FlipVertSelector
@onready var bgm_slider: HSlider = %BGMSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	# 0 = Yes and 1 = No for all of these
	enable_animation_selector.set_index(0 if SettingsManager.animation_flicker else 1)
	flip_horiz_selector.set_index(0 if SettingsManager.upside_down_horizontal_controls_relative_to_player else 1)
	flip_vert_selector.set_index(0 if SettingsManager.upside_down_vertical_controls_relative_to_player else 1)
	bgm_slider.value = SettingsManager.BGM_volume
	sfx_slider.value = SettingsManager.SFX_volume

func set_description_text(text: String) -> void:
	description.text = text

func _on_enable_animation_selector_selected_option_changed(option: StringName) -> void:
	match option.to_lower():
		"yes":
			SettingsManager.animation_flicker = true
		"no":
			SettingsManager.animation_flicker = false
		_:
			push_warning("Unrecognized option selected in EnableAnimationSelector")

func _on_flip_horiz_selector_selected_option_changed(option: StringName) -> void:
	match option.to_lower():
		"yes":
			SettingsManager.upside_down_horizontal_controls_relative_to_player = true
		"no":
			SettingsManager.upside_down_horizontal_controls_relative_to_player = false
		_:
			push_warning("Unrecognized option selected in FlipHorizSelector")

func _on_flip_vert_selector_selected_option_changed(option: StringName) -> void:
	match option.to_lower():
		"yes":
			SettingsManager.upside_down_vertical_controls_relative_to_player = true
		"no":
			SettingsManager.upside_down_vertical_controls_relative_to_player = false
		_:
			push_warning("Unrecognized option selected in FlipVertSelector")

func _on_back_button_pressed() -> void:
	SceneManager.switch_to_previous_scene()

func _on_bgm_slider_value_changed(value: float) -> void:
	SettingsManager.BGM_volume = value

func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.SFX_volume = value
