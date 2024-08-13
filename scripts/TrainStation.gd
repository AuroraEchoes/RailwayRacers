extends Node3D

@export var TRAIN_STATION_COLOR: Global.TrainColor = Global.TrainColor.YELLOW

@onready var station_collision: Area3D = $Area3D
var entered_train: Train

func _ready():
	station_collision.area_entered.connect(_on_area_entered)
	station_collision.area_exited.connect(_on_area_exited)


func _process(delta):
	if entered_train != null:
		if entered_train.get_velocity() < 0.01:
			var ui_manager: UIManager = $/root/Level/UI
			ui_manager.add_score(entered_train.calculate_value())
			entered_train.dollar_destroy()
			entered_train = null

func _on_area_entered(body: Node3D):
	if body.get_parent().is_class("PathFollow3D"):
		var train: Train = body.get_parent().get_parent()
		if train.train_color() == TRAIN_STATION_COLOR:
			entered_train = train

func _on_area_exited(body: Node3D):
	if body.get_parent().is_class("PathFollow3D"):
		var exited_train: Train = body.get_parent().get_parent()
		if entered_train != null:
			if entered_train.get_path() == exited_train.get_path():
				entered_train = null
