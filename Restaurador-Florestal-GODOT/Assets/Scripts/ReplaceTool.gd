@tool
extends Node

# --- Configuração ---
@export var target_group_path: NodePath = NodePath("") # se vazio, percorre a cena inteira
@export var match_list: Array[String] = ["stump_square", "stump_square.dae"] # substrings a procurar no mesh path
@export var new_scene_path: String = "res://Assets/TSCN/Stump_Square_bill.tscn"
@export var ignore_owner_check: bool = false # se true, substituirá mesmo em instâncias externas

# Toggle para executar pelo Inspector (reseta automaticamente)
@export var run_replace: bool = false:
	set(value):
		if value:
			_do_replace()
			run_replace = false

func _on_run_replace(value: bool) -> void:
	if value and Engine.is_editor_hint():
		_do_replace()
	# reseta sempre (evita recursão)
	run_replace = false


func _do_replace() -> void:
	var scene_root = get_tree().get_edited_scene_root()
	if not scene_root:
		push_error("❌ Nenhuma cena aberta para edição.")
		return

	# decide onde procurar
	var start_node: Node = scene_root
	if target_group_path != NodePath(""):
		var n = scene_root.get_node_or_null(target_group_path)
		if n:
			start_node = n
		else:
			push_warning("⚠ target_group_path não encontrado: %s — varrendo a cena toda." % target_group_path)

	print("🔍 Procurando meshes para substituir em:", start_node.name)
	var replaced_count: int = 0
	_replace_all_nodes(start_node, scene_root, replaced_count)
	print("✅ Substituição concluída. Total substituído:", replaced_count)


func _replace_all_nodes(node: Node, scene_root: Node, replaced_count: int) -> void:
	# use uma cópia da lista de filhos para evitar problemas ao modificar a árvore durante a iteração
	var children := node.get_children()
	for child in children:
		# recursão primeiro para garantir profundidade (ou pode trocar para pós-ordem se preferir)
		_replace_all_nodes(child, scene_root, replaced_count)

		# checa tipo e propriedade
		if child is MeshInstance3D:
			# se precisar respeitar owner (evita alterar instâncias externas)
			if not ignore_owner_check and child.owner != scene_root:
				continue

			var mesh: Mesh = child.mesh
			var path: String = ""
			if mesh:
				# resource_path pode ser "" para imports embutidos — usamos fallback para str(mesh)
				path = mesh.resource_path if mesh.resource_path != "" else str(mesh)
			print("DEBUG:", child.name, "→", path)

			# verifica se algum item da match_list aparece no path
			var matches := false
			for m in match_list:
				if m == "":
					continue
				if m in path:
					matches = true
					break

			if matches:
				var new_scene = ResourceLoader.load(new_scene_path)
				if not new_scene or not new_scene is PackedScene:
					push_error("❌ Não foi possível carregar PackedScene em: %s" % new_scene_path)
					return

				var new_instance = new_scene.instantiate()
				# tenta preservar transform/nome/owner
				if new_instance is Node3D:
					new_instance.transform = child.transform
				new_instance.name = child.name
				new_instance.owner = scene_root

				var parent = child.get_parent()
				if parent:
					var idx = parent.get_children().find(child)
					# remove e libera o antigo, adiciona o novo na mesma posição
					parent.remove_child(child)
					child.free() # remove do editor
					parent.add_child(new_instance)
					parent.move_child(new_instance, idx)
					replaced_count += 1
					print("✅ Substituído:", new_instance.name, " (filho de", parent.name, ")")
				else:
					push_warning("⚠ Nó sem parent: %s" % child.name)
