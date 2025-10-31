extends Control
class_name Shop

# Array de Resources de prédios
@export var predios_data: Array[PredioData] = []

var main_ref  # referência para o Main
@onready var descricao_label: Label = $Descrição

func _ready():
	for i in range(get_children().size()):
		var slot = get_children()[i]
		if slot is PredioSlot:
			slot.main_ref = main_ref
			if i < predios_data.size():
				slot.set_slot_data(predios_data[i])

func update_descricao(new_text: String) -> void:
	
	descricao_label.text = new_text
	descricao_label.add_theme_color_override("font_color", Color.BLACK)
	


func _on_close_menu_shop_button_pressed() -> void:
	SoundMana.tocar_som(SoundMana.CONFIRMA)
	main_ref.input_enabled = true
	queue_free() # Replace with function body.
