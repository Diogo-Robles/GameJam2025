extends AnimatedSprite2D

@onready var PlayerNode = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if PlayerNode.HoldingItem == "Axe":
		self.play("Selected1")
	elif PlayerNode.HoldingItem == "Water":
		self.play("Selected2")
	else:
		self.play("Selected3")
