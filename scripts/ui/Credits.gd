extends Node

@onready var back_to_main_menu: Button = $MarginContainer/VBoxContainer/BackToMainMenu
func _ready():
	back_to_main_menu.pressed.connect(func(): Global.load_level("ui-main_menu", self))
