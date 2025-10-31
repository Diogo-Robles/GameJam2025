class_name HighLightTile
extends Node2D

func _process(delta: float) -> void:
	follow_mouse_position()

func follow_mouse_position() -> void:
	var mouse_position: Vector2i = get_global_mouse_position() / 32
	position = mouse_position * 32
	
	
	
	
