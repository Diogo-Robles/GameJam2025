class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://Predios/Inventario_Predios/PredioSlot.tscn")

@export var data : InventarioData


func _ready() -> void:
	clear_inventory()
	update_inventory()
	
	
func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()

func update_inventory() -> void:
	for s in data.construcoes:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.data_predio = s

		get_child( 0 ).grab_focus()
