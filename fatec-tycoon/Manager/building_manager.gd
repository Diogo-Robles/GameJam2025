class_name BuildingManager
extends Node

@export var tile_map : TileMapLayer = null
var cena_menu_construcao: PackedScene = preload("res://Predios/Inventario_Predios/shop.tscn")
@onready var ui_root : CanvasLayer = $"../UI"


const  IS_BUIDABLE : String = "buildable"
const PREDIO_GROUP : String = "PREDIO_GROUP"
var ui_node: Node = null
var used_tiles : Array[Vector2i] = []

func _ready():
	print("UI ROOT:", ui_root)


func abrir_menu_construcao(cell_position: Vector2i) -> void:
	print("DEBUG cena_menu_construcao:", cena_menu_construcao)
	if cena_menu_construcao == null:
		push_warning("Cena de menu de construção não atribuída!")
		return
	
