extends Node3D

@onready var wind_cooldown: Timer = $WindCooldown
@onready var wind_length: Timer = $WindLength
@onready var wind_player: AudioStreamPlayer = $WindPlayer


func _on_wind_cooldown_timeout() -> void:
	wind_length.wait_time = randf_range(3.0, 7.0)
	wind_length.start()
	
	wind_player.play()
	print("start wind")


func _on_wind_length_timeout() -> void:
	wind_cooldown.wait_time = randf_range(10.0, 15.0)
	wind_cooldown.start()
	
	wind_player.stop()
	print("stop wind")
