extends PathFollow3D
class_name TrainCarriage

const CARGO_COAL: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CargoCoal.tscn")
const CARGO_ROCKS: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CargoRocks.tscn")
const CARGO_LUMBER: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CargoLumber.tscn")
const CARGO_OIL_RED: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CargoOilRed.tscn")
const CARGO_OIL_YELLOW: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CargoOilYellow.tscn")
const CARGO_CRATE_RED: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CrateRed.tscn")
const CARGO_CRATE_GREEN: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CrateGreen.tscn")
const CARGO_CRATE_BLUE: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_CrateBlue.tscn")
const PASSANGER_RED: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_PassangerRed.tscn")
const PASSANGER_YELLOW: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_PassangerYellow.tscn")
const PASSANGER_GREEN: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_PassangerGreen.tscn")
const HIGH_SPEED_BLUE: PackedScene = preload("res://scenes/trains/train_meshes/Carriage_HighSpeedBlue.tscn")

const HIGHLIGHT_SHADER: ShaderMaterial = preload("res://resources/TrainHighlightMat.tres")

@export var HOVER_COLOR: Vector3 = Vector3(0.6, 0.6, 0.2)
@export var SELECTED_COLOR: Vector3 = Vector3(0.2, 0.8, 0.2)

@onready var collision: Area3D = $Area3D
var carriage_type: Global.CarriageType = Global.CarriageType.CARGO_COAL
var hovered: bool = false

func _ready():
	collision.mouse_entered.connect(_on_mouse_entered)
	collision.mouse_exited.connect(_on_mouse_exited)
	collision.area_entered.connect(_on_area_entered)
	match carriage_type:
		Global.CarriageType.CARGO_COAL:
			add_child(CARGO_COAL.instantiate())
		Global.CarriageType.CARGO_ROCKS:
			add_child(CARGO_ROCKS.instantiate())
		Global.CarriageType.CARGO_LUMBER:
			add_child(CARGO_LUMBER.instantiate())
		Global.CarriageType.CARGO_OIL_RED:
			add_child(CARGO_OIL_RED.instantiate())
		Global.CarriageType.CARGO_OIL_YELLOW:
			add_child(CARGO_OIL_YELLOW.instantiate())
		Global.CarriageType.CARGO_CRATE_RED:
			add_child(CARGO_CRATE_RED.instantiate())
		Global.CarriageType.CARGO_CRATE_GREEN:
			add_child(CARGO_CRATE_GREEN.instantiate())
		Global.CarriageType.CARGO_CRATE_BLUE:
			add_child(CARGO_CRATE_BLUE.instantiate())
		Global.CarriageType.PASSANGER_RED:
			add_child(PASSANGER_RED.instantiate())
		Global.CarriageType.PASSANGER_YELLOW:
			add_child(PASSANGER_YELLOW.instantiate())
		Global.CarriageType.PASSANGER_GREEN:
			add_child(PASSANGER_GREEN.instantiate())
		Global.CarriageType.HIGH_SPEED_BLUE:
			add_child(HIGH_SPEED_BLUE.instantiate())
	if $CarriageMesh != null:
		$CarriageMesh.material_overlay = HIGHLIGHT_SHADER.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("select") and hovered:
		var parent: Train = get_parent()
		parent._on_select()

func _on_area_entered(enterant: Area3D):
	# This is a dumb way of doing this, but it's also a fast way of doing this
	if enterant.get_collision_layer_value(2):
		if enterant.get_parent().get_parent().get_path() != get_parent().get_path():
			explode()
		# enterant.get_parent().get_parent().explode()

func explode():
	get_parent().explode()

func highlight():
	$CarriageMesh.material_overlay.set_shader_parameter("enabled", true)
	$CarriageMesh.material_overlay.set_shader_parameter("highlight_color", HOVER_COLOR)

func unhighlight():
	$CarriageMesh.material_overlay.set_shader_parameter("enabled", false)

func select():
	$CarriageMesh.material_overlay.set_shader_parameter("enabled", true)
	$CarriageMesh.material_overlay.set_shader_parameter("highlight_color", SELECTED_COLOR)

func deselect():
		$CarriageMesh.material_overlay.set_shader_parameter("enabled", false)

func _on_mouse_entered():
	hovered = true
	var parent: Train = get_parent()
	parent._on_mouse_entered()

func _on_mouse_exited():
	hovered = false
	var parent: Train = get_parent()
	parent._on_mouse_exited()
