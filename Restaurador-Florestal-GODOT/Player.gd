extends CharacterBody3D
class_name Player
#Relacionados a movimento aqui em baixo
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 3.0
var jump_speed = 2.0

@onready var camera = $Camera3D
@export var sensibilidade = 0.02

@onready var rotation_x = global_rotation.x
@onready var rotation_y = global_rotation.y

#relacionados a interação aqui a baixo
@export var max_outline_distance: float = 1.50
@export var interact_distance: float = 2.0
@export var interact_angle: float = 35.0
var current_outline_target: Node3D = null 

#relacionado a item aqui em baixo
@export var HoldingItem: String = "Axe"

#indica que vegetação é a area onde o player esta
var PlayerArea: String = "DefaultValue"

var PlantedTrees: int = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_process_mouse_motion(event.relative)
	if event.is_pressed():
		var actions = InputMap.get_actions()
		for acao_name in actions:
			if event.is_action_pressed(acao_name):
				processar_acao(acao_name)
				break

func _process_mouse_motion(relative: Vector2) -> void:
	rotation_x -= relative.y * sensibilidade
	rotation_y -= relative.x * sensibilidade
	
	rotation_x = clamp(rotation_x, deg_to_rad(-89), deg_to_rad(89))
	
	camera.rotation.x = rotation_x
	rotation.y = rotation_y

func processar_acao(acao: StringName):
	match acao:
		"Item_1":
			HoldingItem = "Axe"
			print("item 1")
		"Item_2":
			HoldingItem = "Water"
			print("item 2")
		"Item_3":
			HoldingItem = "Seed" 
			print("item 3")
			
func _physics_process(delta: float) -> void:
	
	#sobre movimento
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
	move_and_slide()
	#fim da parte de movimento
	#Sobre interagiveis:		
	var interact_target: Node3D = null
	var potential_target = get_closest_interactable()
	if potential_target and can_interact(potential_target):
		interact_target = potential_target

	var outline_target: Node3D = null
	if interact_target:
		var distance = global_transform.origin.distance_to(interact_target.global_transform.origin)
		if distance <= max_outline_distance:
			outline_target = interact_target
	
	if outline_target != current_outline_target:
		if current_outline_target:
			current_outline_target.set_outline_visible(false)
			if "set_sprite_visible" in current_outline_target:
				current_outline_target.set_sprite_visible(false)
		if outline_target:
			outline_target.set_outline_visible(true)
			if "set_sprite_visible" in outline_target:
				outline_target.set_sprite_visible(true)
				
		current_outline_target = outline_target

	if interact_target and Input.is_action_just_pressed("interact"):
		interact_target.interact(self)
		if current_outline_target:
			current_outline_target.set_outline_visible(false)
			if "set_sprite_visible" in current_outline_target:
				current_outline_target.set_sprite_visible(false)
			current_outline_target = null
	#fim do sobre interagiveis
	


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
	var target_center = get_target_center(target)
	
	var distance = global_transform.origin.distance_to(target.global_transform.origin)
	if distance > interact_distance:
		return false

	var camera_forward = -$Camera3D.global_transform.basis.z.normalized()
	var to_target = (target_center - $Camera3D.global_transform.origin).normalized()
	var angle_deg = rad_to_deg(acos(camera_forward.dot(to_target)))
	if angle_deg > interact_angle:
		return false

	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	
	query.from = $Camera3D.global_transform.origin
	query.to = target_center
	query.exclude = [self.get_rid()]
	
	var result = space.intersect_ray(query)
	
	if not result.is_empty():
		var hit_collider = result["collider"]
		
		var current_node = hit_collider
		while current_node:
			if current_node == target:
				return true
			current_node = current_node.get_parent()
			
		return false

	return true
func get_target_center(target: Node3D) -> Vector3:

	var visual_node = target.find_child("*", true, false) 

	if visual_node and "get_aabb" in visual_node:
		var aabb: AABB = visual_node.get_aabb()
		var local_center = aabb.get_center()
		return visual_node.to_global(local_center)
	
	return target.global_transform.origin
