extends Path3D
class_name Train

const CARRIAGE_SCN: PackedScene = preload("res://scenes/trains/TrainCarriage.tscn")
const EXPLOSION_SCN: PackedScene = preload("res://scenes/Explosion.tscn")
const DOLLAR_DESTROY_SCN: PackedScene = preload("res://scenes/DollarDissolve.tscn")
const HIGHLIGHT_SHADER: ShaderMaterial = preload("res://resources/TrainHighlightMat.tres")

const CARGO_BLUE: PackedScene = preload("res://scenes/trains/train_meshes/Train_CargoBlue.tscn")
const CARGO_GREEN: PackedScene = preload("res://scenes/trains/train_meshes/Train_CargoGreen.tscn")
const CARGO_RED: PackedScene = preload("res://scenes/trains/train_meshes/Train_CargoRed.tscn")
const CARGO_YELLOW: PackedScene = preload("res://scenes/trains/train_meshes/Train_CargoYellow.tscn")
const HIGH_SPEED_BLUE: PackedScene = preload("res://scenes/trains/train_meshes/Train_HighSpeedBlue.tscn")
const PASSANGER_GREEN: PackedScene = preload("res://scenes/trains/train_meshes/Train_PassangerGreen.tscn")
const PASSANGER_RED: PackedScene = preload("res://scenes/trains/train_meshes/Train_PassangerRed.tscn")
const PASSANGER_YELLOW: PackedScene = preload("res://scenes/trains/train_meshes/Train_PassangerYellow.tscn")
const TRAM_BLUE: PackedScene = preload("res://scenes/trains/train_meshes/Train_TramBlue.tscn")
const TRAM_RED: PackedScene = preload("res://scenes/trains/train_meshes/Train_TramRed.tscn")
const TRAM_YELLOW: PackedScene = preload("res://scenes/trains/train_meshes/Train_TramYellow.tscn")

@export var HOVER_COLOR: Vector3 = Vector3(0.6, 0.6, 0.2)
@export var SELECTED_COLOR: Vector3 = Vector3(0.2, 0.8, 0.2)
@export var MAX_VELOCITY: float = 0.50
@export var ACCELERATION: float = 0.01
@export var TRAIN_COLOR: Global.TrainColor = Global.TrainColor.YELLOW
@export var TRAIN_TYPE: Global.TrainType = Global.TrainType.REGULAR_PASSANGER
@export var CARRIAGES: Array[Global.CarriageType] = []
@export var CARRIAGE_OFFSET: Vector3 = Vector3(0, 0, 3.0)

@onready var clickbox: Area3D = $Locomotive/ClickBox
@onready var grid: GridMap = $"../GridMap"
@onready var locomotive: PathFollow3D = $Locomotive
@onready var mesh: MeshInstance3D
@onready var get_money_audio: AudioStreamPlayer3D = $GetMoneyAudioPlayer
@onready var spawn_audio: AudioStreamPlayer3D = $TrainSpawnAudioPlayer
@onready var train_running_audio: AudioStreamPlayer3D = $TrainRunningAudioPlayer

var hovered: bool = false
var selected: bool = false
var segment_queue: Array[Vector3] = []
var velocity: float = 0.0
var rollover_velocity: float = 0.0
var instantiated_carriages: Array[TrainCarriage] = []
var pos_along_path: float = 0.0
var exploding: bool = false

var living_time: float = 0.0

# IMPORTANT
# NOTES FOR AURORA TOMORROW
# You're working on the algorithm for making trains follow tracks
# What you have is mostly trash.
# This should all go in _physics_process and use delta time
# For some reason, rotating screws up our movement
# Obviously, it shouldn't.
# But also, we need to do some extra processing anyway
# Like looking a bit ahead to graduate turns, to slow down, etc.
# Basically we need to not just think about the next node
# anyway...
# I hope you slept well, and presume you didn't
# <3 love you past aurora

func _ready():
	spawn_audio.play()
	curve = curve.duplicate()
	clickbox.mouse_entered.connect(_on_mouse_entered)
	clickbox.mouse_exited.connect(_on_mouse_exited)
	clickbox.area_entered.connect(_on_area_entered)
	match TRAIN_TYPE:
		Global.TrainType.CARGO:
			match TRAIN_COLOR:
				Global.TrainColor.RED:
					_add_locomotive_child(CARGO_RED)
				Global.TrainColor.YELLOW:
					_add_locomotive_child(CARGO_YELLOW)
				Global.TrainColor.GREEN:
					_add_locomotive_child(CARGO_GREEN)
				Global.TrainColor.BLUE:
					_add_locomotive_child(CARGO_BLUE)
			ACCELERATION = 0.01
			MAX_VELOCITY = 0.2
		Global.TrainType.REGULAR_PASSANGER:
			match TRAIN_COLOR:
				Global.TrainColor.RED:
					_add_locomotive_child(PASSANGER_RED)
				Global.TrainColor.YELLOW:
					_add_locomotive_child(PASSANGER_YELLOW)
				Global.TrainColor.GREEN:
					_add_locomotive_child(PASSANGER_GREEN)
				_:
					push_warning("Tried to add a passanger train in a colour that doesn't exist")
			ACCELERATION = 0.02
			MAX_VELOCITY = 0.3
		Global.TrainType.HIGH_SPEED_PASSANGER:
			match TRAIN_COLOR:
				Global.TrainColor.BLUE:
					_add_locomotive_child(HIGH_SPEED_BLUE)
				_:
					push_warning("Tried to add a high speed train in a colour that doesn't exist")
			ACCELERATION = 0.07
			MAX_VELOCITY = 0.8
		Global.TrainType.TRAM:
			match TRAIN_COLOR:
				Global.TrainColor.RED:
					_add_locomotive_child(TRAM_RED)
				Global.TrainColor.YELLOW:
					_add_locomotive_child(TRAM_YELLOW)
				Global.TrainColor.BLUE:
					_add_locomotive_child(TRAM_BLUE)
				_:
					push_warning("Tried to add a tram in a colour that doesn't exist")
			ACCELERATION = 0.04
			MAX_VELOCITY = 0.2
	mesh = $Locomotive/TrainMesh
	if mesh != null:
		mesh.material_overlay = HIGHLIGHT_SHADER.duplicate()
	for c in CARRIAGES:
		ACCELERATION -= 0.25 * ACCELERATION
		MAX_VELOCITY -= 0.25 * MAX_VELOCITY

func _process(delta):
	if exploding: return
	if velocity > 0 and !train_running_audio.playing:
		train_running_audio.play()
	elif velocity == 0.0 and train_running_audio.playing:
		train_running_audio.stop()
	# Input
	if Input.is_action_just_pressed("select") and hovered:
		_on_select()
	elif Input.is_action_just_pressed("select") and selected:
		_on_deselect()

func _physics_process(delta):
	living_time += delta
	if exploding: return
	if curve.point_count > 0:
		velocity = min(velocity + (ACCELERATION * delta), MAX_VELOCITY)
		locomotive.progress += velocity
		for i: int in range(len(instantiated_carriages)):
			var carrige: PathFollow3D = instantiated_carriages[i]
			var carriage_max_traversal: float = curve.get_baked_length() - (CARRIAGE_OFFSET.length() * (i + 1))
			carrige.progress += velocity
			carrige.progress = min(carrige.progress, carriage_max_traversal)
		if locomotive.progress_ratio == 1.0:
			_do_funky_buisness()
			pass
	else:
		velocity = 0.0

# Teleport the Line3D such that the Locomotive is now at the origin
# This allows us to clear the points on the Curve3D without nuking everything
func _do_funky_buisness():
	curve.clear_points()
	for carriage in instantiated_carriages:
		carriage.progress = 0.0
		carriage.position -= locomotive.position
	var base_offset: Vector3 = position + locomotive.position
	position = base_offset
	locomotive.progress = 0
	locomotive.position = Vector3.ZERO

func _add_locomotive_child(train_scn: PackedScene):
	var train: MeshInstance3D = train_scn.instantiate()
	locomotive.add_child(train)

func _generate_carriages():
	for i in range(len(CARRIAGES)):
		# spawn carriage (please do it thanks)
		var carriage: TrainCarriage = CARRIAGE_SCN.instantiate()
		carriage.carriage_type = CARRIAGES[i]
		carriage.position = CARRIAGE_OFFSET * (i + 1)
		add_child(carriage)
		instantiated_carriages.push_back(carriage)

func _on_mouse_entered():
	if exploding: return
	hovered = true
	mesh.material_overlay.set_shader_parameter("enabled", true)
	mesh.material_overlay.set_shader_parameter("highlight_color", HOVER_COLOR)
	for c in instantiated_carriages:
		c.highlight()

func _on_mouse_exited():
	if exploding: return
	hovered = false
	if not selected:
		mesh.material_overlay.set_shader_parameter("enabled", false)
		for c in instantiated_carriages:
			c.unhighlight()

func _on_area_entered(enterant: Area3D):
	if exploding: return
	if enterant.get_collision_layer_value(2):
		if enterant.get_parent().get_parent().get_path() != get_path():
			explode()

func _on_select():
	if exploding: return
	selected = true
	mesh.material_overlay.set_shader_parameter("enabled", true)
	mesh.material_overlay.set_shader_parameter("highlight_color", SELECTED_COLOR)
	for c in instantiated_carriages:
		c.select()
	StaticSignalManager.player_selected_train.emit(get_path())

func _on_deselect():
	if exploding: return
	selected = false
	mesh.material_overlay.set_shader_parameter("enabled", false)
	for c in instantiated_carriages:
			c.deselect()
	StaticSignalManager.player_deselected_train.emit()

func go_to(location: Vector3i):
	var back_point: Vector3 = locomotive.global_position
	if len(instantiated_carriages) > 0:
		back_point = instantiated_carriages[-1].global_position
	# var start_tile: Vector3i = grid.local_to_map(back_point)
	# this is ONLY the path from the front of the locomotive
	# We need to prepend the points from the back point to here
	var points: Array[Vector3] = grid.find_path_but_dont_let_the_stupid_fucking_train_do_a_180_and_combust(locomotive.global_position, get_carriage_tile_pos(), location)
	# ...which is what THIS is doing
	var prepoints_lets_get_to_the_start_line = grid.points_of_path(back_point, grid.local_to_map(locomotive.global_position))
	prepoints_lets_get_to_the_start_line.pop_back()
	points = prepoints_lets_get_to_the_start_line + points
	# print(prepoints_lets_get_to_the_start_line, points)
	if len(points) > 0:
		curve.clear_points()
		var offset_point: Vector3 = points[0]
		for point: Vector3 in points:
			if points.count(point) == 1:
				curve.add_point(point - position)
		 # Fix train offsets
		locomotive.progress = CARRIAGE_OFFSET.length() * len(instantiated_carriages)
		for i in range(len(instantiated_carriages)):
			instantiated_carriages[i].progress = CARRIAGE_OFFSET.length() * (len(instantiated_carriages) - i - 1)

# This SHOULD return a Vector3
# But because GDscript is shit it won't deal with nullable types
# ... not using C# was a mistake :(
# Just like the invention of GDscript!
func get_carriage_tile_pos():
	if len(instantiated_carriages) > 0:
		return locomotive.position - instantiated_carriages[-1].position
	return null

func get_velocity() -> float:
	return velocity

func train_color() -> Global.TrainColor:
	return TRAIN_COLOR

func set_carriages(carriages: Array[Global.CarriageType]):
	CARRIAGES = carriages
	_generate_carriages()

func explode():
	if exploding: return
	exploding = true
	for child in get_children():
		var explosion: Node3D = EXPLOSION_SCN.instantiate()
		explosion.position = child.position
		add_child(explosion)
		await get_tree().create_timer(0.1).timeout
		child.queue_free()
	await get_tree().create_timer(1.2).timeout
	queue_free()

func dollar_destroy():
	exploding = true
	get_money_audio.play()
	for child in get_children():
		if child.is_class("PathFollow3D"):
			var explosion: Node3D = DOLLAR_DESTROY_SCN.instantiate()
			explosion.position = child.position
			add_child(explosion)
			await get_tree().create_timer(0.1).timeout
			child.queue_free()
	await get_tree().create_timer(1.2).timeout
	queue_free()

func calculate_value() -> float:
	var value: float = 0.0
	# Because trams are only one car long, they need to be counted as score
	if TRAIN_TYPE == Global.TrainType.TRAM:
		value += 150.0
	for carriage in CARRIAGES:
		var carriage_value: float = 0.0
		var decay_coefficient: float = 1.0
		match carriage:
			Global.CarriageType.CARGO_COAL:
				carriage_value += 100
			Global.CarriageType.CARGO_ROCKS:
				carriage_value += 75
			Global.CarriageType.CARGO_LUMBER:
				carriage_value += 75
			Global.CarriageType.CARGO_OIL_RED:
				carriage_value += 120
			Global.CarriageType.CARGO_OIL_YELLOW:
				carriage_value += 120
			Global.CarriageType.CARGO_CRATE_RED:
				carriage_value += 90
			Global.CarriageType.CARGO_CRATE_GREEN:
				carriage_value += 90
			Global.CarriageType.CARGO_CRATE_BLUE:
				carriage_value += 90
			Global.CarriageType.PASSANGER_RED:
				carriage_value += 70
				decay_coefficient = max(0.5, min(1.0, 1.0 - (0.03 * (living_time - 24))))
			Global.CarriageType.PASSANGER_YELLOW:
				carriage_value += 70
				decay_coefficient = max(0.5, min(1.0, 1.0 - (0.03 * (living_time - 24))))
			Global.CarriageType.PASSANGER_GREEN:
				carriage_value += 70
				decay_coefficient = max(0.5, min(1.0, 1.0 - (0.03 * (living_time - 24))))
			Global.CarriageType.HIGH_SPEED_BLUE:
				carriage_value += 300
				decay_coefficient = max(0.5, min(1.0, 1.0 - (0.04 * (living_time - 18))))
		value += carriage_value * decay_coefficient
	return value
