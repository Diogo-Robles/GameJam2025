#este é um teste para atualizar a tela quando o player trocar de item
extends Label

@onready var PlayerNode = get_tree().get_first_node_in_group("player")

func _process(delta):
	if PlayerNode:
		var item_atual = PlayerNode.HoldingItem 

		if item_atual == "Water":
			self.text = "agua"
		if item_atual == "Axe":
			self.text = "machado"
		if item_atual == "Seed":
			self.text = "semente"
