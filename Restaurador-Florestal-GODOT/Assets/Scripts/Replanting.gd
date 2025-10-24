extends Node3D

@onready var PlayerNode = get_tree().get_first_node_in_group("player")
@onready var TimerNode : Timer = $Timer
#SimpleTrees
const TREE_DEFAULT = preload("res://Assets/TSCN/Trees/Tree_default_replanted.tscn")
const TREE_THIN = preload("res://Assets/TSCN/Trees/tree_thin_Replanted.tscn")
const TREE_SIMPLE = preload("res://Assets/TSCN/Trees/tree_simple_replanted.tscn")
#TallTrees
const TREE_TALL = preload("res://Assets/TSCN/Trees/tree_tall_replanted.tscn")

@export var duration = 300.0

func Crescer(final_scale : float):
	duration = final_scale * 10
	var _tween : Tween = create_tween()
	
	_tween.tween_property(
		self,
		"scale",
		Vector3(final_scale,final_scale,final_scale),
		duration
		)
	_tween.set_ease(Tween.EASE_IN)
	
	_tween.set_trans(Tween.TRANS_BOUNCE)
	

func _ready() -> void:
	var nova_arvore
	if PlayerNode.PlayerArea == "SimpleTrees":
		var rand : int = randi_range(1,3)
		match rand:
			1:
				nova_arvore = TREE_DEFAULT.instantiate()
			2:
				nova_arvore = TREE_SIMPLE.instantiate()
			3:
				nova_arvore = TREE_THIN.instantiate()
	elif PlayerNode.PlayerArea == "TallTrees":
		nova_arvore = TREE_TALL.instantiate()
	if PlayerNode.PlayerArea == "DefaultValue":
		nova_arvore = TREE_DEFAULT.instantiate()
	PlayerNode.PlantedTrees +=1
	add_child(nova_arvore)
	scale = Vector3(0.1,0.1,0.1)
	var rand2 : float = randf_range(1,3)
	Crescer(rand2)
