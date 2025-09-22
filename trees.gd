extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for tree in get_children():
		tree.add_to_group("tree")
