extends MainMenu

func _ready() -> void:
		$BackgroundMusicPlayer.play()
func _on_new_game_button_pressed() -> void:
	$BackgroundMusicPlayer.autoplay = false
	$BackgroundMusicPlayer.stop()
	$BackgroundMusicPlayer.playing = false
	
	load_game_scene()
