extends Node

signal dinheiro_alterado(novo_valor)
signal ciclo_concluido(conhecimento, ganho, novo_saldo)

# Variáveis principais
var dinheiro: float = 1000.0
var conhecimento: int = 0
var verba_base: float = 100.0  # valor base ganho por ciclo
var ciclo_duracao: float = 30.0  
var tempo_ciclo: float = 0.0
var conhecimento_mult = 1
var mult_dinheiro = 1
var preco_ciclo_upg = 20000
var preco_mult_upg = 10000
var preco_desp_upg = 10000

var predios_construidos: Array = []  # lista de prédios construídos
var despesas_totais: float = 0.0     # soma das despesas de todos prédios

func _process(delta: float) -> void:
	tempo_ciclo += delta
	if tempo_ciclo >= ciclo_duracao:
		aplicar_ciclo()
		tempo_ciclo = 0.0


func aplicar_ciclo() -> void:
	conhecimento += 2 * conhecimento_mult
	
	# Cada ponto de conhecimento aumenta a verba em 2%
	var bonus_percentual = conhecimento * 0.02
	var ganho_ciclo = verba_base * (1.0 + bonus_percentual)
	
	dinheiro += ganho_ciclo
	dinheiro = dinheiro * mult_dinheiro
	if despesas_totais > 0:
		dinheiro -= despesas_totais
		if dinheiro < 0:
			dinheiro = 0
	emit_signal("dinheiro_alterado", dinheiro)
	emit_signal("ciclo_concluido", conhecimento, ganho_ciclo, dinheiro)
	
	print("--------------------------------")
	print("Ciclo concluído!")
	print("Conhecimento:", conhecimento)
	print("Bônus:", str(round(bonus_percentual * 100)), "%")
	print("Despesas:", round(despesas_totais))
	print("Ganho no ciclo:", round(ganho_ciclo))
	print("Novo saldo:", round(dinheiro))
	SoundMana.tocar_som(SoundMana.CICLO)

func registrar_predio(predio_data):
	if predio_data == null:
		push_warning("PredioData nulo em registrar_predio()!")
		return
	
	var despesa = predio_data.preco * 0.3
	predios_construidos.append(predio_data)
	despesas_totais += despesa
	print("Prédio registrado:", predio_data.nome)
	print("Despesa adicionada:", despesa, "| Total:", despesas_totais)
