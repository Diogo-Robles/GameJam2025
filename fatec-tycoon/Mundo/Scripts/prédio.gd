extends Node
class_name Construcao

# Identificação básica
var nome: String
var tipo: ConstructionType
var descricao: String

# valor de custo e manutencao de cada predio
var preco: int
var custo_manutencao: int

# efeito causado a cada fim de ciclo na construcao
var ganho_verba: int = 0
var ganho_conhecimento: int = 0
var ganho_sustentabilidade: float = 0.0
var total_alunos: int = 0

# total de dependencia de uma classe(ex: só pode ter 1 cantina, então total_construcao = 1)
var total_construcoes: int = 0
var requer_sustantabilidade: float = 0.0 # ex: precisa de campus saudável em certa porcentagem

# estado de construcao e tempo
var construido: bool = false
var tempo_construcao: float = 2.0

func iniciar_ciclio():
# retorna o custo de manutenção (para o sistema econômico)
return -custo_manutencao

func encerrar_ciclo():
# ta escrito no nome da funcao oq ela faz
return {
"verba": ganho_verba,
"conhecimento": ganho_conhecimento,
"sustentabilidade": ganho_sustentabilidade
}
