#esse é o script de interação dos tocos de madeira
extends Node3D

const ITEM_CENA = preload("res://Assets/TSCN/Plantable.tscn")


#nodes necessarias
@onready var PlayerNode = get_tree().get_first_node_in_group("player")
@onready var Timing: Timer =  get_tree().get_first_node_in_group("Timer")
@onready var WarningLabel : Label = get_tree().get_first_node_in_group("WarningLabel")

#config do outline
const OUTLINE_COLOR = Color(0.809, 0.955, 0.0, 1.0)
const OUTLINE_SCALE = 1.03
var outline_mesh: MeshInstance3D = null
#sprite
@onready var SpriteNoToco: Sprite3D = $Sprite3D

func find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var found_mesh = find_first_mesh_instance(child)
		if found_mesh:
			return found_mesh
			
	return null
func _ready():

	var main_mesh = find_first_mesh_instance(self)

	if main_mesh == null:
		print("DEBUG: Mesh principal não encontrada")

	if main_mesh and main_mesh is MeshInstance3D:
		var mesh_resource = main_mesh.mesh

		if mesh_resource == null:
			print("DEBUG: O MeshInstance3D encontrado ('%s') não possui um recurso Mesh atribuído." % main_mesh.name)
			return

		outline_mesh = MeshInstance3D.new()
		outline_mesh.mesh = mesh_resource
		outline_mesh.scale = Vector3.ONE * OUTLINE_SCALE 
		outline_mesh.visible = false

		var outline_material = StandardMaterial3D.new()
		outline_material.albedo_color = OUTLINE_COLOR
		
		outline_material.emission_enabled = true
		outline_material.emission = OUTLINE_COLOR
		outline_material.emission_energy_multiplier = 2.0 # Torna-o mais brilhante
		outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED 

		outline_material.cull_mode = BaseMaterial3D.CULL_FRONT
		
		var surface_count = mesh_resource.get_surface_count()
		print("DEBUG: Aplicando material de outline em %d superfícies." % surface_count)
	
		for i in range(surface_count):
			outline_mesh.set_surface_override_material(i, outline_material)
		add_child(outline_mesh)
	
	add_to_group("interactables")
	
func set_outline_visible(visibilidade: bool):
	if outline_mesh:
		outline_mesh.visible = visibilidade 
		
func interact(player):
	print("--- INTERAGIDO! ---")
	print("Objeto interágivel:", name, " foi ativado.")
	print("O jogador que interagiu é:", player.name)
	
	set_outline_visible(false)
	if player.HoldingItem == "Axe": 
		WarningLabel.text = ""
		set_process(false)
		spawnar_e_remover()
		remove_from_group("interactables")
	else:
		WarningLabel.text = "Use um machado para quebrar!"
		Timing.wait_time = 2.0
		Timing.one_shot = true
		Timing.start()
		await Timing.timeout
		WarningLabel.text = ""

func spawnar_e_remover():
	
	var novo_item = ITEM_CENA.instantiate()

	novo_item.global_transform.basis = global_transform.basis
	novo_item.global_position = global_position
	novo_item.scale = Vector3(0.5,0.5,0.5)
	
	print("Item plantavel spawnado na posição: ", novo_item.global_position)
	
	get_parent().add_child(novo_item)
	
	print("Item de madeira spawnado na posição: ", novo_item.global_position)
	queue_free()

func set_sprite_visible(visibilidade: bool):
	if SpriteNoToco:
		SpriteNoToco.visible = visibilidade
