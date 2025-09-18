class_name Torch
extends Node3D

@export var noise: NoiseTexture3D
var time_passed: float = 0.0

var is_moving: bool = false
var torch_tween_y: Tween
var torch_tween_x: Tween

@onready var holder: Node3D = $Holder
@onready var omni_light_3d: OmniLight3D = $Holder/OmniLight3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"


func _process(delta: float) -> void:
	time_passed += delta
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)
	
	omni_light_3d.light_energy = sampled_noise * 16
	
	if Input.is_action_just_pressed("move_forward"):
		bounce_torch()
	elif Input.is_action_just_released("move_forward"):
		stop_torch_bounce()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shield_candle"):
		animation_player.play("cover_candle")
	elif Input.is_action_just_released("shield_candle"):
		animation_player.play_backwards("cover_candle")


func bounce_torch():
	torch_tween_y = get_tree().create_tween()
	torch_tween_y.set_loops()
	torch_tween_y.tween_property(holder, "position:y", 0.1, 0.5)
	torch_tween_y.tween_property(holder, "position:y", 0, 0.5)
	
	torch_tween_x = get_tree().create_tween()
	torch_tween_x.set_loops()
	torch_tween_x.tween_property(holder, "position:x", 0.1, 1)
	torch_tween_x.tween_property(holder, "position:x", -0.1, 1)

func stop_torch_bounce():
	torch_tween_y.pause()
	torch_tween_x.pause()
