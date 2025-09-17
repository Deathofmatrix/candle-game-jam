class_name CameraController
extends Node3D

var mouse_locked := false

@export var mouse_sensitivity :float = 0.0002
@onready var camera_3d: Camera3D = $Camera3D


func _unhandled_input(event):
	if event is InputEventMouseButton and not mouse_locked:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_locked = true
	elif event is InputEventKey and event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_locked = false
	
	if event is InputEventMouseMotion and mouse_locked:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_3d.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-30), deg_to_rad(30))
		rotation.y = clamp(rotation.y, deg_to_rad(-30), deg_to_rad(30))
