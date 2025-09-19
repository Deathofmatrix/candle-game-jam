class_name Torch
extends Node3D

@export var noise: NoiseTexture3D
var time_passed: float = 0.0

var is_moving: bool = false
var torch_tween_y: Tween
var torch_tween_x: Tween

var torch_level: float = 100

@onready var holder: Node3D = $Holder
@onready var omni_light_3d: OmniLight3D = $Holder/OmniLight3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var outside_fire_particles: CPUParticles3D = $Holder/OmniLight3D/OutsideFireParticles
@onready var fire_particles: CPUParticles3D = $Holder/OmniLight3D/FireParticles
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Holder/AudioStreamPlayer3D
@onready var footstep_player: AudioStreamPlayer3D = %FootstepPlayer
@onready var player_path_follow: PlayerController = $".."

func _process(delta: float) -> void:
	time_passed += delta
	torch_level -= delta
	omni_light_3d.omni_range = remap(torch_level, 0, 100, 2.5, 16)
	
	if torch_level <= 0:
		torch_expire()
		omni_light_3d.omni_range = 0
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)
	
	omni_light_3d.light_energy = sampled_noise * 16
	
	if Input.is_action_just_pressed("move_forward"):
		bounce_torch()
		is_moving = true
	elif Input.is_action_just_released("move_forward"):
		stop_torch_bounce()
		is_moving = false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shield_candle"):
		animation_player.play("cover_candle")
		player_path_follow.speed = 0.6
		if Input.is_action_pressed("move_forward"):
			stop_torch_bounce()
			bounce_torch()
	elif Input.is_action_just_released("shield_candle"):
		animation_player.play_backwards("cover_candle")
		player_path_follow.speed = 1
		if Input.is_action_pressed("move_forward"):
			stop_torch_bounce()
			bounce_torch()


func bounce_torch():
	torch_tween_y = get_tree().create_tween()
	torch_tween_y.set_loops()
	torch_tween_y.tween_property(holder, "position:y", 0.1, 0.4 / player_path_follow.speed)
	torch_tween_y.tween_property(holder, "position:y", 0, 0.4 / player_path_follow.speed)
	
	torch_tween_x = get_tree().create_tween()
	torch_tween_x.set_loops()
	torch_tween_x.tween_property(holder, "position:x", 0.1, 0.8 / player_path_follow.speed)
	torch_tween_x.tween_callback(play_footstep_sound.bind(0.35))
	torch_tween_x.tween_property(holder, "position:x", -0.1, 0.8 / player_path_follow.speed)
	torch_tween_x.tween_callback(play_footstep_sound.bind(-0.35))


func stop_torch_bounce():
	torch_tween_y.pause()
	torch_tween_x.pause()


func torch_expire():
	fire_particles.emitting = false
	outside_fire_particles.emitting = false
	audio_stream_player_3d.stop()


func play_footstep_sound(x_pos: float):
	footstep_player.position.x = x_pos
	footstep_player.pitch_scale = randf_range(1.0, 1.1)
	footstep_player.play(0.45)
	
