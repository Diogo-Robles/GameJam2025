extends Control

@onready var verba_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/VerbaBase
@onready var ganho_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/GanhoConhecimento
@onready var despesa_label: Label = $TextureRect/VBoxContainer2/VBoxContainer/Despesas
@onready var close_button: Button = $TextureRect/VBoxContainer2/Fechar

func _ready():
	close_button.pressed.connect(_on_fechar_pressed)
	_update_labels()

func _update_labels():
	# Usa os valores atuais da Economia
	verba_label.text = "💰 Verba Base: " + str(Economia.verba_base)
	verba_label.add_theme_font_size_override("font_size",20)
	ganho_label.text = "📘 Ganho por Conhecimento: " + str((Economia.conhecimento * 0.12 * 100))  + "%"
	ganho_label.add_theme_font_size_override("font_size",20)
	despesa_label.text = "💸 Despesas: " + str(Economia.despesas_totais)
	despesa_label.add_theme_font_size_override("font_size",20)

	


func _on_fechar_pressed() -> void:
	queue_free()
