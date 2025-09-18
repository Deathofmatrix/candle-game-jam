@tool
extends Node3D

@export var noise: NoiseTexture3D
var time_passed: float = 0.0

var is_moving: bool = false
var torch_tween: Tween

@onready var holder: Node3D = $Holder
@onready var omni_light_3d: OmniLight3D = $Holder/OmniLight3D

func _process(delta: float) -> void:
	time_passed += delta
	
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	sampled_noise = abs(sampled_noise)
	
	omni_light_3d.light_energy = sampled_noise * 16



func bounce_torch():
	var torch_tween = get_tree().create_tween()
	torch_tween.set_loops()
	torch_tween.tween_property(holder, "position:y", 0.1, 0.5)
	torch_tween.tween_property(holder, "position:y", 0, 0.5)

func stop_torch_bounce():
	torch_tween.pause()
