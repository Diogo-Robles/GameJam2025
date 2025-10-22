extends TextureRect

@onready var PlayerNode = get_tree().get_first_node_in_group("player")
var anim_texture: AnimatedTexture

func _ready():
	if self.texture is AnimatedTexture:
		print("aaaaaaaa")
		anim_texture = self.texture as AnimatedTexture
		anim_texture.pause = true
	else:
		print("⚠️ A textura do próprio nó não é uma AnimatedTexture. Verifique o Inspector.")

func _process(delta: float) -> void:
	
	var frame_to_set = 0
	match PlayerNode.HoldingItem:
		"Axe":
			frame_to_set = 1
		"Water":
			frame_to_set = 2
		"Seed":
			frame_to_set = 3
			
	trocar_frame_por_script(frame_to_set)

func trocar_frame_por_script(novo_frame: int):
	anim_texture.current_frame = novo_frame
