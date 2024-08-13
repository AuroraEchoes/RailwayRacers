extends Node3D

@onready var tt1: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText1"
@onready var tt2: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText2"
@onready var tt3: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText3"
@onready var tt4: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText4"
@onready var tt5: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText5"
@onready var tt6: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText6"
@onready var tt7: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText7"
@onready var tt8: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText8"
@onready var tt9: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText9"
@onready var tt10: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText10"
@onready var tt11: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText11"
@onready var tt12: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText12"
@onready var tt13: RichTextLabel = $"../TutorialUI/MarginContainer/PanelContainer/MarginContainer/TutText13"
@onready var tbutton: Button = $"../TutorialUI/MarginContainer/PanelContainer/NextTutText"
@onready var ystb: Area3D = $YellowStationTutBox
@onready var gstb: Area3D = $GreenStationTutBox
@onready var grid: GridMap = $"../GridMap"
@onready var station_1: Node3D = $"../TrainStation"
@onready var station_2: Node3D = $"../TrainStation2"
@onready var spawning_platform: Node3D = $"../TrainSpawningPlatform"
@onready var pass_display: Node3D = $"../PassangerTrainsDisplay"
@onready var hispeed_display: Node3D = $"../HighSpeedTrainsDisplay"
@onready var cargo_display: Node3D = $"../CargoTrainsDisplay"
@onready var trams_display: Node3D = $"../TramsDisplay"
@onready var ui: UIManager = $"../UI"
@onready var esc_menu_panel: PanelContainer = $"../UI/MarginContainer/EscMenuPanel"
@onready var level_finished_menu_panel: PanelContainer = $"../UI/MarginContainer/TimeUpPanel"
@onready var tutorial_ui_base: MarginContainer = $"../TutorialUI/MarginContainer"

var current_tt: int = 1
var yellow_entered: bool = false
var green_entered: bool = false

func _ready():
	tbutton.pressed.connect(_next_tut_stage)
	ystb.area_entered.connect(_on_yellow_station_entered)
	gstb.area_entered.connect(_on_green_station_entered)
	pass_display.hide()
	hispeed_display.hide()
	cargo_display.hide()
	trams_display.hide()
	tt1.hide()
	tt2.hide()
	tt3.hide()
	tt4.hide()
	tt5.hide()
	tt6.hide()
	tt7.hide()
	tt8.hide()
	tt9.hide()
	tt10.hide()
	tt11.hide()
	tt12.hide()
	tt13.hide()
	tt1.show()
	tt1.visible_ratio = 0.0
	tt1.create_tween().tween_property(tt1, "visible_ratio", 1.0, 1.0)

func _next_tut_stage():
	if yellow_entered and current_tt < 5:
		current_tt = 6
		tt1.hide()
		tt2.hide()
		tt3.hide()
		tt4.hide()
		tt5.hide()
		tt6.hide()
		tt7.hide()
		tt8.hide()
		tt9.hide()
		tt10.hide()
		tt11.hide()
		tt12.hide()
		tt13.hide()
		tt6.show()
		tt6.visible_ratio = 0.0
		tt6.create_tween().tween_property(tt6, "visible_ratio", 1.0, 1.0)
		return
	if green_entered and current_tt < 7:
		current_tt = 8
		tt1.hide()
		tt2.hide()
		tt3.hide()
		tt4.hide()
		tt5.hide()
		tt6.hide()
		tt7.hide()
		tt8.hide()
		tt9.hide()
		tt10.hide()
		tt11.hide()
		tt12.hide()
		tt13.hide()
		tt8.show()
		tt8.visible_ratio = 0.0
		tt8.create_tween().tween_property(tt8, "visible_ratio", 1.0, 1.0)
		return
	match current_tt:
		1:
			current_tt += 1
			tt1.hide()
			tt2.show()
			tt2.visible_ratio = 0.0
			tt2.create_tween().tween_property(tt2, "visible_ratio", 1.0, 1.0)
		2:
			current_tt += 1
			tt2.hide()
			tt3.show()
			tt3.visible_ratio = 0.0
			tt3.create_tween().tween_property(tt3, "visible_ratio", 1.0, 1.0)
		3:
			current_tt += 1
			tt3.hide()
			tt4.show()
			tt4.visible_ratio = 0.0
			tt4.create_tween().tween_property(tt4, "visible_ratio", 1.0, 1.0)
		4:
			current_tt += 1
			tt4.hide()
			tt5.show()
			tt5.visible_ratio = 0.0
			tt5.create_tween().tween_property(tt5, "visible_ratio", 1.0, 1.0)
		6:
			current_tt += 1
			tt6.hide()
			tt7.show()
			tt7.visible_ratio = 0.0
			tt7.create_tween().tween_property(tt7, "visible_ratio", 1.0, 1.0)
		8:
			grid.hide()
			station_1.hide()
			station_2.hide()
			spawning_platform.hide()
			pass_display.show()
			current_tt += 1
			tt8.hide()
			tt9.show()
			tt9.visible_ratio = 0.0
			tt9.create_tween().tween_property(tt9, "visible_ratio", 1.0, 1.0)
		9:
			pass_display.hide()
			hispeed_display.show()
			current_tt += 1
			tt9.hide()
			tt10.show()
			tt10.visible_ratio = 0.0
			tt10.create_tween().tween_property(tt10, "visible_ratio", 1.0, 1.0)
		10:
			hispeed_display.hide()
			cargo_display.show()
			current_tt += 1
			tt10.hide()
			tt11.show()
			tt11.visible_ratio = 0.0
			tt11.create_tween().tween_property(tt11, "visible_ratio", 1.0, 1.0)
		11:
			cargo_display.hide()
			trams_display.show()
			current_tt += 1
			tt11.hide()
			tt12.show()
			tt12.visible_ratio = 0.0
			tt12.create_tween().tween_property(tt12, "visible_ratio", 1.0, 1.0)
		12:
			current_tt += 1
			tt12.hide()
			tt13.show()
			tt13.visible_ratio = 0.0
			tt13.create_tween().tween_property(tt13, "visible_ratio", 1.0, 1.0)
		13:
			ui._finish_level()

func _on_yellow_station_entered(enterant: Area3D):
	if enterant.get_parent().is_class("PathFollow3D"):
		yellow_entered = true
		if current_tt == 5:
			current_tt += 1
			tt5.hide()
			tt6.show()
			tt6.visible_ratio = 0.0
			tt6.create_tween().tween_property(tt6, "visible_ratio", 1.0, 1.0)

func _on_green_station_entered(enterant: Area3D):
	if enterant.get_parent().is_class("PathFollow3D"):
		green_entered = true
		if current_tt == 7:
			current_tt += 1
			tt7.hide()
			tt8.show()
			tt8.visible_ratio = 0.0
			tt8.create_tween().tween_property(tt8, "visible_ratio", 1.0, 1.0)

func _process(delta):
	if esc_menu_panel.visible or level_finished_menu_panel.visible:
		tutorial_ui_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		tutorial_ui_base.mouse_filter = Control.MOUSE_FILTER_PASS
