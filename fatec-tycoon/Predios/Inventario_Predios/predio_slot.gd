extends Button
class_name PredioSlot

var data_predio : SlotsPredio : set = set_slot_data


@onready var texture_rect: TextureRect = $TextureRect
@export var predio_packed_scene: PackedScene
@onready var sfx_player: AudioStreamPlayer2D = $PobreAudio
@onready var constroi_audio: AudioStreamPlayer2D = $ConstroiAudio



var main_ref  # referência para o Main

func _ready():
	texture_rect.texture = null

	mouse_entered.connect(_on_hover_entered)
	mouse_exited.connect(_on_hover_exited)
	if main_ref == null:
		# assume que Main é o pai da cena
		main_ref = get_tree().current_scene

func _pressed():
	if main_ref and data_predio:
		
		var predio_data = data_predio.predio_data

		# Verifica se há dinheiro suficiente
		if Economia.dinheiro >= predio_data.preco:
			
			# Subtrai o preço do prédio
			Economia.dinheiro -= predio_data.preco

			# Adiciona o prédio à lista e registra a despesa
			Economia.registrar_predio(predio_data)

			# Atualiza o valor de dinheiro na HUD
			Economia.emit_signal("dinheiro_alterado", Economia.dinheiro)

			# Constrói o prédio no mapa
			SoundMana.tocar_som(SoundMana.CONSTROI)
			await get_tree().create_timer(0.1).timeout
			main_ref.place_building(main_ref.selected_tile, predio_data)
			
			# Fecha o menu
			get_parent().get_parent().get_parent().queue_free()
			
			main_ref.input_enabled = true
		else:
			
			SoundMana.tocar_som(SoundMana.ERRO)
			main_ref.instanciar_Modal_Dinheiro()
	
func set_slot_data(value : SlotsPredio) -> void:
	data_predio = value
	if data_predio == null:
		return
	texture_rect.texture = data_predio.predio_data.texture

func _on_hover_entered() -> void:
	if data_predio != null:
		if data_predio.predio_data != null:
			var shop_instance = get_parent().get_parent().get_parent()  # sobe dois níveis, se necessário
			shop_instance.update_descricao(data_predio.predio_data.descricao)
	pass

func _on_hover_exited() -> void:
	var shop_instance = get_parent().get_parent().get_parent()  # sobe dois níveis, se necessário
	shop_instance.update_descricao("")
	pass
