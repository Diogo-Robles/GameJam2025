extends Area3D


@onready var PlayerNode: Node3D = get_tree().get_first_node_in_group("player")

func body_entered(body: Node3D):
	if body == PlayerNode:
		print("aaaaaaaaaa")


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		PlayerNode.PlayerArea = "JungleTrees"
		print(PlayerNode.PlayerArea)


func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		PlayerNode.PlayerArea = "DefaultValue"
		print(PlayerNode.PlayerArea)
