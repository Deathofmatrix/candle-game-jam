extends Node3D

@export var torch: Torch 
@export var noise: FastNoiseLite

@onready var wind_cooldown: Timer = $WindCooldown
@onready var wind_length: Timer = $WindLength
@onready var wind_player: AudioStreamPlayer = $WindPlayer

var volume_db : float
var is_windy = false
var wind_time: float


func _ready() -> void:
	wind_player.stream_paused = true
	volume_db = wind_player.volume_db
	wind_player.volume_db = -35


func _process(delta: float) -> void:
	
	if is_windy:
		wind_time += delta
		print(noise.get_noise_3d(position.x, position.z, wind_time))
		for tree in get_tree().get_nodes_in_group("tree"):
			var noise_value: float = noise.get_noise_3d(tree.position.x, tree.position.z, wind_time)
			var mapped_x: float = remap(noise_value, -1.0, 1.0, -0.15, 0.15)
			
			var noise_value_z: float = noise.get_noise_3d(tree.position.x + 100, tree.position.z + 100, wind_time)
			var mapped_z: float = remap(noise_value_z, -1.0, 1.0, -0.15, 0.15)
			
			tree.rotation.x = mapped_x
			tree.rotation.z = mapped_z


func _on_wind_cooldown_timeout() -> void:
	wind_length.wait_time = randf_range(5.0, 10.0)
	wind_length.start()
	
	tween_volume_to_value_and_set_pause(false, volume_db, 1.0)
	is_windy = true
	print("start wind")
	
	torch.react_to_wind()


func _on_wind_length_timeout() -> void:
	wind_cooldown.wait_time = randf_range(10.0, 15.0)
	wind_cooldown.start()
	
	tween_volume_to_value_and_set_pause(true, -35, 1.0)
	is_windy = false
	print("stop wind")
	
	torch.stop_reacting_to_wind()


func tween_volume_to_value_and_set_pause(set_pause: bool, value: float, time: float):
	var tween: Tween = create_tween()
	if set_pause:
		tween.tween_property(wind_player, "volume_db", value, time)
	tween.tween_property(wind_player, "stream_paused", set_pause, 0)
	tween.tween_property(wind_player, "volume_db", value, time)
