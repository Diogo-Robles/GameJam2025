extends Node
class_name SoundManager

var sfx_player: AudioStreamPlayer

const CLICK = preload("res://Assets/Sons/sons/click1.ogg")
const ERRO = preload("res://Assets/Sons/sons/error_001_semDinheiro.ogg")
const CONFIRMA = preload("res://Assets/Sons/sons/select_004.ogg")
const CONSTROI = preload("res://Assets/Sons/sons/drop_001_colocarConstrucao.ogg")
const CICLO = preload("res://Assets/Sons/sons/confirmation_003.ogg")
const BG_MUSIC = preload("res://Assets/Sons/sons/bgMusic.mp3")
const BG_MUSIC2 = preload("res://Assets/Sons/sons/bgMusic2.mp3")

func _ready():
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

func tocar_som(som: AudioStream):
	sfx_player.stream = som
	sfx_player.play()
