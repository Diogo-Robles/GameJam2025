
extends Node3D

var outline_mesh: MeshInstance3D = null
const READER_UI_SCENE = preload("res://Assets/TSCN/BookMenu.tscn")
#pegando os nodes necessarios
@onready var PlayerNode = get_tree().get_first_node_in_group("player")
@onready var Timing: Timer =  get_tree().get_first_node_in_group("Timer")
@onready var WarningLabel : Label = get_tree().get_first_node_in_group("WarningLabel")
@onready var HUD = get_tree().get_first_node_in_group("hud")

#config de outline
const OUTLINE_COLOR = Color(0.809, 0.955, 0.0, 1.0)
const OUTLINE_SCALE = 1.1 
#sprite
@onready var SpriteBook: Sprite3D = $Sprite3D


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
	
		
func set_outline_visible(visible: bool):
	if outline_mesh:
		outline_mesh.visible = visible

func interact(player):
	print("--- INTERAGIDO! ABRINDO LIVRO ---")
	
	var reader_ui = READER_UI_SCENE.instantiate()
	if reader_ui.has_signal("menu_closed"):
		reader_ui.menu_closed.connect(player._on_book_menu_closed)
	else:
		print("ERRO: O menu de leitura não tem o sinal 'menu_closed'!")
		
	get_tree().get_root().add_child(reader_ui)

	set_outline_visible(false)
	set_sprite_visible(false)
	HUD.visible = false

func set_sprite_visible(visibilidade: bool):
	if SpriteBook:
		SpriteBook.visible = visibilidade

func set_sprite_texture(new_texture: Texture2D):
	if SpriteBook:
		SpriteBook.texture = new_texture
