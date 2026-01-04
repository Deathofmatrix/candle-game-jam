class_name PlayerController
extends PathFollow3D

@export var speed := 1.0

@onready var candle: Torch = $Candle

func _process(delta: float) -> void:
	if progress_ratio >= 0.9:
		candle.stabilise_light = true
	if progress_ratio >= 0.98:
		end_game()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		move_forward(delta)


func move_forward(delta: float):
	progress += speed * delta


func end_game():
	$"../../Control/WinScreen".visible = true
