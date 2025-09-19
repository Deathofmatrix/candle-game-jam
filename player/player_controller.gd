class_name PlayerController
extends PathFollow3D

@export var speed := 1.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		move_forward(delta)


func move_forward(delta: float):
	progress += speed * delta
