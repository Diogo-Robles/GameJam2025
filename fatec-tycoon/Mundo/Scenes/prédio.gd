# Building.gd
extends Node2D
class_name Building

@export var predio_data : PredioData
@onready var sprite: Sprite2D = $Sprite
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	atualizar_predio()

func set_predio_data(data: PredioData) -> void:
	predio_data = data
	atualizar_predio()

func atualizar_predio() -> void:
	if predio_data:
		# Aplica textura
		if predio_data.texture:
			sprite.texture = predio_data.texture
		else:
			print("Aviso: PredioData sem textura!")

		# Aplica hitbox se houver
		if predio_data.hitbox_shape:
			collision.shape = predio_data.hitbox_shape
		else:
			# Cria hitbox padrão baseada no sprite
			if sprite.texture:
				var rect = RectangleShape2D.new()
				rect.extents = sprite.texture.get_size() * 0.5 * sprite.scale
				collision.shape = rect

# Detecta clique manualmente usando o Sprite ou CollisionShape
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		# Verifica se o clique está dentro do sprite
		if sprite.get_rect().has_point(sprite.to_local(mouse_pos)):
			_on_building_clicked()

func _on_building_clicked():
	if predio_data:
		print("Prédio clicado:", predio_data.nome)
		# Aqui você pode abrir modal ou menu com detalhes
