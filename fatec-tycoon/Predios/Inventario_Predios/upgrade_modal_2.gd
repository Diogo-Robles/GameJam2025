extends Control
class_name HUD

var preco_ciclo = 100
@export var main_ref: Node  # referência para o nó Main
@onready var botao_renda: Button = $TextureRect/VBoxContainer/BotaoRenda
@onready var botao_conhecimento: Button = $TextureRect/VBoxContainer/BotaoConhecimento
@onready var botao_despesas: Button = $TextureRect/VBoxContainer/BotaoDespesas

func _ready():
	botao_renda.pressed.connect(_on_botao_renda_pressed)
	botao_conhecimento.pressed.connect(_on_botao_conhecimento_pressed)
	botao_despesas.pressed.connect(_on_botao_despesas_pressed)

# --- FUNÇÕES DOS UPGRADES ---
func _process(delta: float) -> void:
	botao_conhecimento.text = "-1s de Ciclo: " + str(Economia.preco_ciclo_upg)
	botao_renda.text = "+0.5 de renda: " + str(Economia.preco_mult_upg)
	botao_despesas.text = "-0.5 de despesas: " + str(Economia.preco_desp_upg)

func _on_botao_renda_pressed():
	if Economia.dinheiro >= Economia.preco_mult_upg:  # custo do upgrade
		Economia.dinheiro -= Economia.preco_mult_upg
		Economia.mult_dinheiro += 0.5
		Economia.preco_mult_upg *= 2
		Economia.emit_signal("dinheiro_alterado", Economia.dinheiro)
	else:
		print("Dinheiro insuficiente para upgrade de renda.")

func _on_botao_conhecimento_pressed():
	
	if Economia.dinheiro >= Economia.preco_ciclo_upg:
		Economia.dinheiro -= Economia.preco_ciclo_upg
		Economia.ciclo_duracao -= 1
		Economia.preco_ciclo_upg *= 2
		Economia.emit_signal("dinheiro_alterado", Economia.dinheiro)
	else:
		print("Dinheiro insuficiente para upgrade de conhecimento.")

func _on_botao_despesas_pressed():
	if Economia.dinheiro >= Economia.preco_desp_upg:
		Economia.dinheiro -= Economia.preco_desp_upg
		Economia.despesas_totais *= 0.9  # reduz despesas em 10%
		Economia.preco_desp_upg *= 2
		Economia.emit_signal("dinheiro_alterado", Economia.dinheiro)
	else:
		print("Dinheiro insuficiente para reduzir despesas.")


func _on_fechar_pressed() -> void:
	queue_free() # Replace with function body.
