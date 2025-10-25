extends Node3D

@onready var PlayerNode = get_tree().get_first_node_in_group("player")
@onready var TimerNode : Timer = $Timer
@onready var Growth = $GrowthParticle
#SimpleTrees
const TREE_DEFAULT = preload("res://Assets/TSCN/Trees/Tree_default_replanted.tscn")
const TREE_THIN = preload("res://Assets/TSCN/Trees/tree_thin_Replanted.tscn")
const TREE_SIMPLE = preload("res://Assets/TSCN/Trees/tree_simple_replanted.tscn")
#TallTrees
const TREE_TALL = preload("res://Assets/TSCN/Trees/tree_tall_replanted.tscn")

#JungleTrees
const JUNGLE_TREE = preload("res://Assets/TSCN/Trees/tree_plateau-replanted.tscn")
@export var duration = 100

func Crescer(final_scale : float):
	var _tween : Tween = create_tween()
	Growth.start_effect()
	_tween.finished.connect(Growth.stop_effect)
	
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
	var rand : int = randi_range(1,3)
	var randMinRange = 1
	var randMaxRange = 3
	match PlayerNode.PlayerArea:
		"SimpleTrees":
			match rand:
				1:
					nova_arvore = TREE_DEFAULT.instantiate()
				2:
					nova_arvore = TREE_SIMPLE.instantiate()
				3:
					nova_arvore = TREE_THIN.instantiate()
		"TallTrees":
			nova_arvore = TREE_TALL.instantiate()
		"JungleTrees":
			randMinRange = 4
			randMaxRange = 7
			nova_arvore = JUNGLE_TREE.instantiate()
		"DefaultValue":
			nova_arvore = TREE_DEFAULT.instantiate()
			
	PlayerNode.PlantedTrees +=1
	add_child(nova_arvore)
	scale = Vector3(0.1,0.1,0.1)
	var rand2 : float = randf_range(randMinRange,randMaxRange)
	Crescer(rand2)
