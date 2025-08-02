extends VBoxContainer

@onready var audio_manager = get_node("/root/AudioManager")

@export var volume_type: AudioManager.VolumeType
@export var slider_label: String

# ===== ui components =====
@onready var volume_slider: HSlider = $SliderContainer/VolumeSlider
@onready var volume_percent: Label = $SliderContainer/VolumePercent
@onready var volume_label: Label = $VolumeLabel

func _ready() -> void:
	if volume_label:
		volume_label.text = slider_label

	if audio_manager:
		var current_volume = audio_manager.get_volume_by_type(volume_type) * 100
		volume_slider.value = current_volume
		update_volume_display(current_volume)

func _on_volume_slider_value_changed(value: float) -> void:
	var volume_normalized = value / 100.0
	audio_manager.set_volume_by_type(volume_type, volume_normalized)
	update_volume_display(value)

func update_volume_display(value: float) -> void:
	volume_percent.text = str(int(value)) + "%"
