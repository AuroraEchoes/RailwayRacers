extends Node3D

@onready var line_renderer = $LineRenderer
@onready var grid: TrainGameboard = $"../GridMap"
@onready var camera: Camera3D = $"../Camera3D"
var train: Train
var selected: bool = false
var selected_path: Array[Vector3] = []
var selected_mouse_tile = null

func _ready():
	StaticSignalManager.player_selected_train.connect(_on_player_selected_train)
	StaticSignalManager.player_deselected_train.connect(_on_player_deselected_train)

func _process(delta):
	if train != null:
		# Try and find where the mouse is
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var ray_start_pos: Vector3 = camera.project_ray_origin(mouse_pos)
		var ray_end_pos: Vector3 = ray_start_pos + camera.project_ray_normal(mouse_pos) * 1000
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_start_pos, ray_end_pos)
		var intersect_point: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		
		if !intersect_point.is_empty():
			var mouse_pos_3d: Vector3 = intersect_point.position
			var train_pos_tile: Vector3i = grid.local_to_map(train.global_position)
			var mouse_pos_tile: Vector3i = grid.local_to_map(mouse_pos_3d)
			selected_mouse_tile = mouse_pos_tile
			# i can feel my sanity draining away
			# like slime sliding out of a frying pan
			selected_path = grid.find_path_but_dont_let_the_stupid_fucking_train_do_a_180_and_combust(train_pos_tile, train.get_carriage_tile_pos(), mouse_pos_tile)
			var adjusted_path: Array[Vector3] = []
			for t: Vector3 in selected_path:
				adjusted_path.push_back(t + Vector3(0.0, 0.0, 0.5))
			line_renderer.points = adjusted_path
		else:
			selected_mouse_tile = null
			line_renderer.points = []

func _on_player_selected_train(path: NodePath):
	train = get_node_or_null(path)

func _on_player_deselected_train():
	if selected_mouse_tile != null and selected_path != []:
		train.go_to(selected_mouse_tile)
		line_renderer.points = []
	train = null
