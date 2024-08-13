extends Control

@onready var tutorial: Button = $MarginContainer/VBoxContainer/MenuButtons/Tutorial
@onready var levels: Button = $MarginContainer/VBoxContainer/MenuButtons/Levels
@onready var settings: Button = $MarginContainer/VBoxContainer/MenuButtons/Settings
@onready var credits: Button = $MarginContainer/VBoxContainer/MenuButtons/Credits
@onready var quit: Button = $MarginContainer/VBoxContainer/MenuButtons/Quit

func _ready():
	tutorial.pressed.connect(_on_tutorial_button_press)
	levels.pressed.connect(_on_tutorial_levels_press)
	settings.pressed.connect(func(): Global.load_level("ui-settings", self))
	credits.pressed.connect(func(): Global.load_level("ui-credits", self))
	quit.pressed.connect(_on_quit_button_press)

func _on_tutorial_button_press():
	Global.load_level("lvl_0", self)

func _on_tutorial_levels_press():
	Global.load_level("ui-level_select", self)

func _on_quit_button_press():
	get_tree().quit()
