extends Control

const StatsModal = preload("res://Mundo/Scenes/StatsModal.tscn")
const UPGRADE_MODAL_2 = preload("res://Predios/Inventario_Predios/UpgradeModal2.tscn")
const TUTORIAL = preload("res://Mundo/Scenes/Tutorial.tscn")
@onready var dinheiro_text: Label = $GridContainer/HBoxContainer2/HBoxContainer/Dinheiro
@onready var tempo_text: Label = $GridContainer/HBoxContainer2/HBoxContainer/Tempo
@onready var ponto_conhecimento_text: Label = $GridContainer/HBoxContainer2/HBoxContainer/PontoConhecimento
@onready var close_audio: AudioStreamPlayer2D = $CloseAudio

@export var play_texture: Texture
@export var play_texture_press: Texture

@export var pause_texture: Texture
@export var pause_texture_press: Texture

@onready var pause_btn: Button = $GridContainer/HBoxContainer2/HBoxContainer2/Pause2




@export var doubleSpeed: Texture
@export var normalSpeed: Texture


var is_fast := false
var game_state = true

func _ready() -> void:
	# Atualiza os textos iniciais
	_atualizar_dinheiro(Economia.dinheiro)
	_atualizar_conhecimento(Economia.conhecimento)
	
	# Conecta aos sinais da classe global
	Economia.connect("dinheiro_alterado", Callable(self, "_atualizar_dinheiro"))
	Economia.connect("ciclo_concluido", Callable(self, "_atualizar_ciclo"))


func _process(delta: float) -> void:
	# Atualiza o tempo restante do ciclo
	var tempo_restante = Economia.ciclo_duracao - Economia.tempo_ciclo
	var minutos = int(tempo_restante) / 60
	var segundos = int(tempo_restante) % 60
	tempo_text.text = "Tempo: %02d:%02d" % [minutos, segundos]
	tempo_text.add_theme_font_size_override("font_size",25)


func _atualizar_dinheiro(novo_valor: float) -> void:
	dinheiro_text.text = "Dinheiro: " + str(round(novo_valor))
	dinheiro_text.add_theme_font_size_override("font_size", 25)

func _atualizar_conhecimento(novo_valor: int) -> void:
	ponto_conhecimento_text.text = "Conhecimento: " + str(novo_valor)
	ponto_conhecimento_text.add_theme_font_size_override("font_size", 25)

func _atualizar_ciclo(conhecimento: int, ganho: float, novo_saldo: float) -> void:
	ponto_conhecimento_text.text = "Conhecimento: " + str(conhecimento)
	# Atualiza o dinheiro também ao final do ciclo
	_atualizar_dinheiro(novo_saldo)


func _on_button_pressed() -> void:
	SoundMana.tocar_som(SoundMana.CONFIRMA)
	var tutorial_instance = TUTORIAL.instantiate()
	add_child(tutorial_instance)


func _on_pause_pressed() -> void:
	
	if game_state == true:
		SoundMana.tocar_som(SoundMana.CONFIRMA)
		await get_tree().create_timer(0.1).timeout
		game_state = false
		get_tree().paused = true
	elif game_state == false:
		get_tree().paused = false
		game_state = true
		SoundMana.tocar_som(SoundMana.CONFIRMA)





func _on_x_speed_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Engine.time_scale = 2.0
	else:
		Engine.time_scale = 1.0


func _on_stats_pressed() -> void:
	SoundMana.tocar_som(SoundMana.CONFIRMA)

	# Instancia e adiciona o modal na tela
	var modal = StatsModal.instantiate()
	add_child(modal)

	# Opcional: centraliza
	modal.set_anchors_preset(Control.PRESET_CENTER)


func _on_upg_modal_pressed() -> void:
	var upg = UPGRADE_MODAL_2.instantiate()
	add_child(upg)# Replace with function body.
