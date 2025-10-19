# Exemplo de script para um objeto interágivel (Interactable.gd)
extends Node3D

var outline_mesh: MeshInstance3D = null

# Configuração do Outline
const OUTLINE_COLOR = Color(0.809, 0.955, 0.0, 1.0) # Ciano
const OUTLINE_SCALE = 1.03 # Aumentado para 3% (Mais visível)
func find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var found_mesh = find_first_mesh_instance(child)
		if found_mesh:
			return found_mesh
			
	return null
func _ready():
	# 1. Encontra a Mesh principal
	# Altere "Mesh" se o seu MeshInstance3D tiver outro nome (ex: "stump_mesh")
	var main_mesh = find_first_mesh_instance(self)

	# DEBUG: Verifica se a mesh foi encontrada
	if main_mesh == null:
		print("DEBUG: Mesh principal não encontrada! Verifique se o nome do nó filho é 'Mesh'.")

	if main_mesh and main_mesh is MeshInstance3D:
		var mesh_resource = main_mesh.mesh
		
		# 2. Verifica se o recurso Mesh existe antes de clonar
		if mesh_resource == null:
			print("DEBUG: O MeshInstance3D encontrado ('%s') não possui um recurso Mesh atribuído." % main_mesh.name)
			return
			
		# 3. Cria a Mesh do Outline
		outline_mesh = MeshInstance3D.new()
		outline_mesh.mesh = mesh_resource # Usa a mesma geometria
		outline_mesh.scale = Vector3.ONE * OUTLINE_SCALE # Amplia ligeiramente
		outline_mesh.visible = false # Começa invisível
		
		# 4. Cria um material para o Outline (StandardMaterial3D simples)
		var outline_material = StandardMaterial3D.new()
		outline_material.albedo_color = OUTLINE_COLOR
		
		# Configura o material para ser emissivo e não sombreado (sempre visível)
		outline_material.emission_enabled = true
		outline_material.emission = OUTLINE_COLOR
		outline_material.emission_energy_multiplier = 2.0 # Torna-o mais brilhante
		outline_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED 

		# Culling frontal: desenha apenas o "verso" da mesh
		outline_material.cull_mode = BaseMaterial3D.CULL_FRONT
		
		# 5. Aplica o material em todas as superfícies da mesh
		var surface_count = mesh_resource.get_surface_count()
		print("DEBUG: Aplicando material de outline em %d superfícies." % surface_count)
		
		# Itera sobre o número de superfícies definidas no recurso Mesh
		for i in range(surface_count):
			outline_mesh.set_surface_override_material(i, outline_material)

		# 6. Adiciona como filho
		add_child(outline_mesh)
	
	add_to_group("interactables")
	
func set_outline_visible(visible: bool):
	if outline_mesh:
		outline_mesh.visible = visible # Apenas liga/desliga a visibilidade da mesh ampliada
		
func interact(player):
	print("--- INTERAGIDO! ---")
	print("Objeto interágivel:", name, " foi ativado.")
	print("O jogador que interagiu é:", player.name)
	
	set_outline_visible(false)

	set_process(false)
	remove_from_group("interactables")
