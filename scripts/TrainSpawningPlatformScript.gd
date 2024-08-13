extends Node3D

const TRAIN: PackedScene = preload("res://scenes/trains/Train.tscn")

@export var spawn_queue: Array[TrainPokeball]

@onready var area: Area3D = $Area3D
@onready var next_spawn_label: Label3D = $TimeUntilNextSpawn
@onready var timer: Timer = $Timer

func _ready():
	if len(spawn_queue) > 0:
		timer.wait_time = spawn_queue[0].spawn_delay
		timer.timeout.connect(_spawn_next)
		timer.start()

func _process(delta):
	if len(spawn_queue) > 0:
		if area.has_overlapping_areas():
			next_spawn_label.font_size = 128
			next_spawn_label.text = "Train Spawning Blocked"
		else:
			next_spawn_label.font_size = 200
			next_spawn_label.text = "Next Train: " + str(ceili(timer.time_left)) + "s"
		match spawn_queue[0].color:
			Global.TrainColor.RED:
				next_spawn_label.modulate = Color(0.8, 0.2, 0.2, 1.0)
			Global.TrainColor.GREEN:
				next_spawn_label.modulate = Color(0.2, 0.8, 0.2, 1.0)
			Global.TrainColor.YELLOW:
				next_spawn_label.modulate = Color(0.8, 0.8, 0.2, 1.0)
			Global.TrainColor.BLUE:
				next_spawn_label.modulate = Color(0.2, 0.2, 0.8, 1.0)
	if !area.has_overlapping_areas() and timer.is_stopped() and len(spawn_queue) > 1:
		timer.start()
	elif area.has_overlapping_areas():
		timer.stop()

func _spawn_next():
	_throw_that_pokeball_babyyyy(spawn_queue[0])
	spawn_queue.pop_front()
	if len(spawn_queue) > 1:
		timer.wait_time = spawn_queue[0].spawn_delay

func _throw_that_pokeball_babyyyy(train: TrainPokeball):
	var inst_train: Train = TRAIN.instantiate()
	inst_train.TRAIN_COLOR = train.color
	inst_train.TRAIN_TYPE = train.type
	inst_train.position = position + Vector3(2, 0, 0).rotated(Vector3.UP, rotation.y)
	inst_train.position.y = 0.5
	get_node("/root/Level").add_child(inst_train)
	inst_train.set_carriages(train.carriages)
