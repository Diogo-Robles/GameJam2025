extends Camera2D

@export var zoomSpeed: float = 10.0
@export var map_size: Vector2 = Vector2(1152, 648)  # tamanho máximo do mapa

var zoomTarget: Vector2
var dragStartMousePos = Vector2.ZERO
var dragStartCameraPos = Vector2.ZERO
var isDragging: bool = false

func _ready() -> void:
	zoomTarget = zoom
	make_current()

func _process(delta: float) -> void:
	_zoom(delta)
	_pan(delta)
	_click_and_drag()
	_clamp_to_map()  # trava a câmera dentro do mapa

func _zoom(delta):
	if Input.is_action_just_pressed("ScrollMouseCima"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("ScrollMouseBaixo"):
		zoomTarget *= 0.9

	# Limita o zoom para não exagerar nem mostrar fora do mapa
	var viewport_size = get_viewport_rect().size
	var min_zoom_x = viewport_size.x / map_size.x
	var min_zoom_y = viewport_size.y / map_size.y
	var min_zoom = max(min_zoom_x, min_zoom_y)  # escolhe o maior pra não sobrar cinza
	
	zoomTarget.x = clamp(zoomTarget.x, min_zoom, 3.0)
	zoomTarget.y = clamp(zoomTarget.y, min_zoom, 3.0)

	zoom = zoom.lerp(zoomTarget, zoomSpeed * delta)

func _pan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("Camera_move_right"):
		moveAmount.x += 1
	if Input.is_action_pressed("Camera_move_left"):
		moveAmount.x -= 1
	if Input.is_action_pressed("Camera_move_up"):
		moveAmount.y -= 1
	if Input.is_action_pressed("Camera_move_down"):
		moveAmount.y += 1

	moveAmount = moveAmount.normalized()
	position += moveAmount * delta * 1000 * (1 / zoom.x)

func _click_and_drag():
	if !isDragging and Input.is_action_just_pressed("Camera_pan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	elif isDragging and Input.is_action_just_released("Camera_pan"):
		isDragging = false

	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos
		position = dragStartCameraPos - moveVector * (1 / zoom.x)

func _clamp_to_map():
	var viewport_size = get_viewport_rect().size / zoom
	var half_view = viewport_size / 2.0

	# Limita a câmera para não sair dos limites do mapa
	position.x = clamp(position.x, half_view.x, map_size.x - half_view.x)
	position.y = clamp(position.y, half_view.y, map_size.y - half_view.y)
