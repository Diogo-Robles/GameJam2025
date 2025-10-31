extends Control

func _ready() -> void:

	get_tree().paused = true

func _on_play_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Mundo/Scenes/tileset.tscn")

func _on_close_button_pressed() -> void:
	
	get_tree().quit()
