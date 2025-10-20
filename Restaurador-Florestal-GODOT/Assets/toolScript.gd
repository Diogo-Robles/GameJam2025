#esta aqui é apenas uma ferramenta que eu estou usando para
#atribuir scripts a varios objetos rapidamente
#feito com ajuda do Gemini

@tool
extends Node 

const INTERACAO_SCRIPT: Script = preload("res://Assets/Scripts/TreeStump.gd") 
const GRUPO_INTERACAO = "interactables"

@export var anexar_e_agrupar: bool = false:
	set(value):
		anexar_e_agrupar = value
		if Engine.is_editor_hint() and anexar_e_agrupar:
			_adicionar_componentes()
			anexar_e_agrupar = false 
			notify_property_list_changed()

func _ready() -> void:
	pass

func _adicionar_componentes():
	var cena_raiz: Node = get_tree().edited_scene_root
	
	if INTERACAO_SCRIPT == null:
		print("ERRO: Script de Interação não foi carregado corretamente.")
		return
	for child in get_children():
		
		if not child.is_in_group(GRUPO_INTERACAO):
			child.add_to_group(GRUPO_INTERACAO)
			print("Nó '%s' adicionado ao grupo '%s'." % [child.name, GRUPO_INTERACAO])
		
		if child.get_script() != INTERACAO_SCRIPT:
			
			child.set_script(INTERACAO_SCRIPT)
			
			if cena_raiz:
				cena_raiz.set_edited(true) 
			
			print("Script 'TreeStump.gd' ANEXADO ao nó filho: " + child.name)
		else:
			print("Script já ANEXADO ao nó: " + child.name)
