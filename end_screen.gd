extends Panel

@export var colour: Color
@export var text_colour: Color

@onready var label: Label = $CenterContainer/Label


func _on_visibility_changed() -> void:
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate", colour, 3.0)
	tween.tween_property(label, "modulate", text_colour, 1.0)
