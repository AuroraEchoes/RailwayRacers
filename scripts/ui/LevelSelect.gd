extends Control

@onready var lvl1: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer1/Level1
@onready var lvl2: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer2/Level2
@onready var lvl3: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer3/Level3
@onready var lvl4: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer4/Level4
@onready var lvl5: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer5/Level5
@onready var lvl6: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer6/Level6
@onready var lvl7: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer7/Level7
@onready var lvl8: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer8/Level8
@onready var lvl9: Button = $MarginContainer/VBoxContainer/GridContainer/PanelContainer9/Level9
@onready var lvl1score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer1/HighScore1
@onready var lvl2score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer2/HighScore2
@onready var lvl3score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer3/HighScore3
@onready var lvl4score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer4/HighScore4
@onready var lvl5score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer5/HighScore5
@onready var lvl6score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer6/HighScore6
@onready var lvl7score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer7/HighScore7
@onready var lvl8score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer8/HighScore8
@onready var lvl9score: Label = $MarginContainer/VBoxContainer/GridContainer/PanelContainer9/HighScore9
@onready var back_to_main_menu: Button = $MarginContainer/VBoxContainer/BackToMainMenu

func _ready():
	lvl1.pressed.connect(func(): _load_level(1))
	lvl2.pressed.connect(func(): _load_level(2))
	lvl3.pressed.connect(func(): _load_level(3))
	lvl4.pressed.connect(func(): _load_level(4))
	lvl5.pressed.connect(func(): _load_level(5))
	lvl6.pressed.connect(func(): _load_level(6))
	lvl7.pressed.connect(func(): _load_level(7))
	lvl8.pressed.connect(func(): _load_level(8))
	lvl9.pressed.connect(func(): _load_level(9))
	lvl1score.text = "High Score: " + str(Global.scores[0])
	lvl2score.text = "High Score: " + str(Global.scores[1])
	lvl3score.text = "High Score: " + str(Global.scores[2])
	lvl4score.text = "High Score: " + str(Global.scores[3])
	lvl5score.text = "High Score: " + str(Global.scores[4])
	lvl6score.text = "High Score: " + str(Global.scores[5])
	lvl7score.text = "High Score: " + str(Global.scores[6])
	lvl8score.text = "High Score: " + str(Global.scores[7])
	lvl9score.text = "High Score: " + str(Global.scores[8])
	back_to_main_menu.pressed.connect(func(): Global.load_level("ui-main_menu", self))

func _load_level(level_num: int):
	Global.load_level("lvl_" + str(level_num), self)
