extends CharacterBody3D

#Relacionados a movimento aqui em baixo
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 3.0
var jump_speed = 2.0

@onready var camera = $Camera3D
@export var sensibilidade = 0.02

var rotation_x = 0.0
var rotation_y = 0.0

#relacionados a interação aqui a baixo

@export var max_outline_distance: float = 1.50 # <-- ADICIONE ESTA LINHA
@export var interact_distance: float = 2.0
@export var interact_angle: float = 25.0
var current_outline_target: Node3D = null # Novo rastreador de alvo com outline

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_process_mouse_motion(event.relative)

func _process_mouse_motion(relative: Vector2) -> void:
	rotation_x -= relative.y * sensibilidade
	rotation_y -= relative.x * sensibilidade
	
	rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
	
	camera.rotation.x = rotation_x
	rotation.y = rotation_y

func _physics_process(delta: float) -> void:
	var input2d := Input.get_vector("move_left", "move_right", "move_back","move_forward")
	var direction: Vector3 = Vector3.ZERO
	
	if input2d.length() > 0:
		var forward = -transform.basis.z
		var right = transform.basis.x
		direction = (right * input2d.x + forward * input2d.y).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	# 1. Encontra o alvo que PODE ser interagido (respeitando ângulo e distância máxima)
	var interact_target: Node3D = null
	var potential_target = get_closest_interactable()
	if potential_target and can_interact(potential_target):
		interact_target = potential_target

	# 2. Decide se o outline deve ser exibido com base na distância
	var outline_target: Node3D = null
	if interact_target:
		var distance = global_transform.origin.distance_to(interact_target.global_transform.origin)
		# Só define um alvo para o outline se a distância for maior que a mínima
		if distance <= max_outline_distance:
			outline_target = interact_target
	
	# 3. Gerencia a visibilidade do outline (lógica que você já tinha, mas usando 'outline_target')
	if outline_target != current_outline_target:
		if current_outline_target:
			current_outline_target.set_outline_visible(false)
		
		if outline_target:
			outline_target.set_outline_visible(true)
		
		current_outline_target = outline_target

	# 4. Processa a ação de interagir (usando 'interact_target' para permitir interação de perto)
	if interact_target and Input.is_action_just_pressed("interact"):
		interact_target.interact(self)
		# Se interagiu, o outline também deve sumir
		if current_outline_target:
			current_outline_target.set_outline_visible(false)
			current_outline_target = null
	move_and_slide()

#Funções de interação aqui em baixo

func get_closest_interactable() -> Node3D:
	var interactables = get_tree().get_nodes_in_group("interactables")
	var closest: Node3D = null
	var min_dist = interact_distance
	for obj in interactables:
		var d = global_transform.origin.distance_to(obj.global_transform.origin)
		if d < min_dist:
			closest = obj
			min_dist = d
	return closest
	

func can_interact(target: Node3D) -> bool:
	# Usa a nova função para obter um ponto de alvo mais preciso
	var target_center = get_target_center(target)
	
	# A distância ainda pode ser calculada a partir da origem do jogador
	var distance = global_transform.origin.distance_to(target.global_transform.origin)
	if distance > interact_distance:
		return false

	# --- CÁLCULO DE ÂNGULO MELHORADO ---
	var camera_forward = -$Camera3D.global_transform.basis.z.normalized()
	# Usa o 'target_center' para o cálculo do ângulo
	var to_target = (target_center - $Camera3D.global_transform.origin).normalized()
	var angle_deg = rad_to_deg(acos(camera_forward.dot(to_target)))
	if angle_deg > interact_angle:
		return false

	# --- RAYCAST MELHORADO ---
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	
	# Origem: A câmera (seus olhos)
	query.from = $Camera3D.global_transform.origin
	# Destino: O centro visual do alvo
	query.to = target_center
	# Opcional: Excluir o próprio jogador do raycast
	query.exclude = [self.get_rid()]
	
	var result = space.intersect_ray(query)
	
	if not result.is_empty():
		var hit_collider = result["collider"]
		
		# Verifica se o colisor atingido pertence ao alvo ou é o próprio alvo
		var current_node = hit_collider
		while current_node:
			if current_node == target:
				return true # Linha de visão limpa para o alvo!
			current_node = current_node.get_parent()
			
		return false # Atingiu outra coisa no caminho
		
	# Se o raio não atingiu nada (improvável, mas possível), considere como linha de visão limpa
	return true
func get_target_center(target: Node3D) -> Vector3:
	# Tenta encontrar um MeshInstance3D ou um CollisionShape3D para usar como referência
	var visual_node = target.find_child("*", true, false) # Encontra o primeiro filho de qualquer tipo

	if visual_node and "get_aabb" in visual_node:
		var aabb: AABB = visual_node.get_aabb()
		var local_center = aabb.get_center()
		return visual_node.to_global(local_center)
	
	# Se não encontrar um nó com AABB, retorna a origem do objeto como fallback
	return target.global_transform.origin
