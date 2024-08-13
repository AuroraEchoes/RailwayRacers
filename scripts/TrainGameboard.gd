extends GridMap
class_name TrainGameboard

@onready var pathfinding: AStar2D
@onready var pathfinding_ids: Dictionary

func _ready():
	_generate_astar()

func _process(delta):
	pass
	
func _generate_astar():
	var astar: AStar2D = AStar2D.new()
	var curr_id: int = 0
	var point_id_dict: Dictionary = {}
	for cell_pos: Vector3i in get_used_cells():
		var cell_pos_2d: Vector2i = Vector2i(cell_pos.x, cell_pos.z)
		astar.add_point(curr_id, Vector2(cell_pos_2d))
		point_id_dict[cell_pos_2d] = curr_id
		var cell_tile_id: int = get_cell_item(cell_pos)
		match cell_tile_id:
			# Vertical straight
			0:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
			# Horizontal straight
			1:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
			# Left-bottom curve
			2:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
			# Left-top curve
			3:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
			# Right-bottom curve
			4:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
			# Right-top curve
			5:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
			# Left-vertical T junction
			6:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
			# Right-vertical T junction
			7:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
			# Bottom-horizontal T junction
			8:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, 1))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
			# Top-horizontal T junction
			9:
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(0, -1))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(1, 0))
				_try_connect_points(astar, point_id_dict, cell_pos_2d, cell_pos_2d + Vector2i(-1, 0))
		curr_id += 1
		#var l: Label3D = Label3D.new()
		#l.position = map_to_local(cell_pos) + Vector3(0, 5, -0.5)
		#l.text = str(cell_pos_2d)
		#l.rotate_x(-45)
		#add_child(l)
	self.pathfinding = astar
	self.pathfinding_ids = point_id_dict
	
func _try_connect_points(astar: AStar2D, point_id_dict: Dictionary, point1: Vector2i, point2: Vector2i):
	var p1 = point_id_dict.get(point1)
	var p2 = point_id_dict.get(point2)
	if p1 != null and p2 != null:
		if !astar.are_points_connected(p1, p2):
			astar.connect_points(p1, p2)

func path(start: Vector3i, end: Vector3i) -> PackedVector2Array:
	var p1 = pathfinding_ids.get(Vector2i(start.x, start.z))
	var p2 = pathfinding_ids.get(Vector2i(end.x, end.z))
	if p1 != null and p2 != null:
		return pathfinding.get_point_path(p1, p2)
	else:
		return []

func find_path_but_dont_let_the_stupid_fucking_train_do_a_180_and_combust(loco: Vector3, to_disconnect, end: Vector3i) -> Array[Vector3]:
	# Temporarily disable the tile that the foremost carriage is sitting on
	# This SHOULD mean that we can't just be like "imma go do a 180 brb" and break everything
	var disabled_ids = []
	if to_disconnect != null:
		var back_of_train: Vector3 = local_to_map(loco - to_disconnect)
		var points: PackedVector2Array = path(local_to_map(loco), back_of_train)
		for point: Vector2i in points:
			# print("the toilet is skibidi")
			# leaving this debug print here instead of deleting it
			# as a reminder to myself of how far this made me fall
			var disabled_id = pathfinding_ids.get(point)
			if disabled_id != null and not disabled_ids.has(disabled_id):
				disabled_ids.push_back(disabled_id)
				pathfinding.set_point_disabled(disabled_id, true)
	# ...pathfind
	var points: Array[Vector3] = points_of_path(loco, end)
	# and bowoop, it never happened
	# if you think it happened you're crazy
	# it literally didn't happen
	# not a single happen
	for id in disabled_ids:
		if id != null:
			pathfinding.set_point_disabled(id, false)
	return points

func points_of_path(start: Vector3, end: Vector3i) -> Array[Vector3]:
	var tile_pos: Vector3i = local_to_map(start)
	var path: PackedVector2Array = path(tile_pos, end)
	# This will happen quite a bit. Shame!
	if len(path) < 1: return []
	var points: Array[Vector3] = [start]
	for i: int in range(len(path)):
		# Last — finish in middle of tile
		if i + 1 >= len(path):
			map_to_local(Vector3i(path[i].x, 0, path[i].y))
			pass
		else:
			var delta: Vector2 = path[i + 1] - path[i]
			var point_offset: Vector3 = map_to_local(Vector3i(path[i].x, 0, path[i].y)) + (cell_size * Vector3(delta.x, 0, delta.y) / 2)
			points.push_back(point_offset)
	return points
