extends Control


func _on_pobre_button_pressed() -> void:
	SoundMana.tocar_som(SoundMana.CONFIRMA)
	queue_free()
