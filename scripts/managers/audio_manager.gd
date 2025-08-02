extends Node

enum VolumeType {
  MUSIC,
  SFX
}

@onready var bgm_player: AudioStreamPlayer = AudioStreamPlayer.new()

var music_volume: float = 0.5
var sfx_volume: float = 0.5

var bgm_resource = preload("res://assets/audio/bgm.mp3")

const MUSIC_BUS = 1
const SFX_BUS = 2

func _ready() -> void:
	setup_audio_bus("Music", MUSIC_BUS)
	setup_audio_bus("SFX", SFX_BUS)

	add_child(bgm_player)
	bgm_player.stream = bgm_resource
	bgm_player.bus = "Music"
	bgm_player.autoplay = false
	bgm_player.play()

	load_audio_settings()

func setup_audio_bus(bus_name, i) -> void:
	var j = AudioServer.get_bus_index(bus_name)
	if j == -1:
		AudioServer.add_bus(i)
		AudioServer.set_bus_name(i, bus_name)


# ===== get/set volume =====

func get_volume_by_type(volume_type: VolumeType) -> float:
	match volume_type:
		VolumeType.MUSIC:
			return music_volume
		VolumeType.SFX:
			return sfx_volume
		_:
			return -1

func set_volume_by_type(volume_type: VolumeType, volume: float) -> void:
	match volume_type:
		VolumeType.MUSIC:
			music_volume = clamp(volume, 0.0, 1.0)
			update_bus_volume("Music", music_volume)
		VolumeType.SFX:
			sfx_volume = clamp(volume, 0.0, 1.0)
			update_bus_volume("SFX", sfx_volume)
	save_audio_settings()

func update_bus_volume(bus_name: String, volume: float) -> void:
	var i = AudioServer.get_bus_index(bus_name)
	if i != -1:
		var volume_db = linear_to_db(volume) if volume > 0 else -80.0
		AudioServer.set_bus_volume_db(i, volume_db)

# ===== save/load audio config =====

func load_audio_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://audio_settings.cfg")

	if err == OK:
		music_volume = config.get_value("audio", "music_volume", 0.8)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	update_bus_volume("Music", music_volume)
	update_bus_volume("SFX", sfx_volume)

func save_audio_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save("user://audio_settings.cfg")

# ===== play/pause sounds =====

func play_sfx(sfx_stream: AudioStream) -> void:
	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

	sfx_player.stream = sfx_stream
	sfx_player.bus = "SFX"
	sfx_player.play()
	sfx_player.finished.connect(func(): sfx_player.queue_free())
