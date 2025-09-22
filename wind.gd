extends Node3D

@export var torch: Torch 

@onready var wind_cooldown: Timer = $WindCooldown
@onready var wind_length: Timer = $WindLength
@onready var wind_player: AudioStreamPlayer = $WindPlayer

var volume_db : float


func _ready() -> void:
	wind_player.stream_paused = true
	volume_db = wind_player.volume_db
	wind_player.volume_db = -35

func _on_wind_cooldown_timeout() -> void:
	wind_length.wait_time = randf_range(5.0, 10.0)
	wind_length.start()
	
	tween_volume_to_value_and_set_pause(false, volume_db, 1.0)
	print("start wind")
	
	torch.react_to_wind()


func _on_wind_length_timeout() -> void:
	wind_cooldown.wait_time = randf_range(10.0, 15.0)
	wind_cooldown.start()
	
	tween_volume_to_value_and_set_pause(true, -35, 1.0)
	print("stop wind")
	
	torch.stop_reacting_to_wind()


func tween_volume_to_value_and_set_pause(set_pause: bool, value: float, time: float):
	var tween: Tween = create_tween()
	if set_pause:
		tween.tween_property(wind_player, "volume_db", value, time)
	tween.tween_property(wind_player, "stream_paused", set_pause, 0)
	tween.tween_property(wind_player, "volume_db", value, time)
	
