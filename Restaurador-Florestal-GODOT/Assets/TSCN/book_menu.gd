extends OverlaidMenu


@onready var PageTexture = $Control/PageTextures
@onready var BtnNext = $Control/Next
@onready var BtnPrev = $Control/Prev
@onready var BtnClose = $Control/Close
@onready var BtnBookFauna = $Control/LivroFauna
@onready var BtnBookFlora = $Control/LivroFlora
@onready var BtnBookSobrevivencia = $Control/LivroSobrevivencia
signal menu_closed
var Fauna: Array[Texture2D] = [
	load("res://Assets/PDFS/PNGs/Fauna/Livro da Fauna - Amazônia-1.png"),
	load("res://Assets/PDFS/PNGs/Fauna/Livro da Fauna - Amazônia-2.png"),
	load("res://Assets/PDFS/PNGs/Fauna/Livro da Fauna - Amazônia-3.png"),
	load("res://Assets/PDFS/PNGs/Fauna/Livro da Fauna - Amazônia-4.png")
]

var Flora: Array[Texture2D] = [
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-1.png"),
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-2.png"),
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-3.png"),
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-4.png"),
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-5.png"),
	load("res://Assets/PDFS/PNGs/Flora/Livro da Flora - Amazônia-6.png")
]

var Sobrevivencia: Array[Texture2D] = [
	load("res://Assets/PDFS/PNGs/Sobrevivencia/Livro da Sobrevivência na Floresta Amazonica (1)-1.png"),
	load("res://Assets/PDFS/PNGs/Sobrevivencia/Livro da Sobrevivência na Floresta Amazonica (1)-2.png"),

]
var LivroAtual := "Fauna"
var PaginasAtuais: Array[Texture2D] = []
var current_page := 0

func _ready():
	# Conecta botões
	BtnNext.pressed.connect(_on_next_pressed)
	BtnPrev.pressed.connect(_on_prev_pressed)
	BtnClose.pressed.connect(_on_close_pressed)
	BtnBookFauna.pressed.connect(func(): mudar_livro("Fauna"))
	BtnBookFlora.pressed.connect(func(): mudar_livro("Flora"))
	BtnBookSobrevivencia.pressed.connect(func(): mudar_livro("Sobrevivencia"))
	
	# Inicializa com Fauna
	mudar_livro("Fauna")
	
	# Configura o TextureRect para não deformar
	PageTexture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED


# Troca de livro
func mudar_livro(nome_livro: String):
	LivroAtual = nome_livro
	current_page = 0
	match nome_livro:
		"Fauna":
			PaginasAtuais = Fauna
		"Flora":
			PaginasAtuais = Flora
		"Sobrevivencia":
			PaginasAtuais = Sobrevivencia
	PageTexture.texture = PaginasAtuais[current_page]

# Próxima página
func _on_next_pressed():
	if current_page < PaginasAtuais.size() - 1:
		current_page += 1
		PageTexture.texture = PaginasAtuais[current_page]

# Página anterior
func _on_prev_pressed():
	if current_page > 0:
		current_page -= 1
		PageTexture.texture = PaginasAtuais[current_page]

# Fechar livro
func _on_close_pressed():
	# Em vez de queue_free(), chame a função base close() do OverlaidMenu.
	# O close() fará: despausar, restaurar o mouse, e então queue_free().
	menu_closed.emit()
	close()
	
	
