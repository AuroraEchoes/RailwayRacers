extends Node

@onready var back_to_main_menu: Button = $MarginContainer/VBoxContainer/BackToMainMenu
@onready var master_slider: Slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/GridContainer/MasterSlider
@onready var music_slider: Slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/GridContainer/MusicSlider
@onready var sfx_slider: Slider = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/GridContainer/SFXSlider

func _ready():
	master_slider.value = Global.master_audio_level
	music_slider.value = Global.music_audio_level
	sfx_slider.value = Global.music_audio_level
	back_to_main_menu.pressed.connect(func(): Global.load_level("ui-main_menu", self))

func _process(_delta):
	Global.master_audio_level = master_slider.value
	Global.music_audio_level = music_slider.value
	Global.sfx_audio_level = sfx_slider.value
