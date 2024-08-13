extends Node

const ui_main_menu: PackedScene = preload("res://scenes/ui/MainMenu.tscn")
const ui_level_select: PackedScene = preload("res://scenes/ui/LevelSelect.tscn")
const ui_settings: PackedScene = preload("res://scenes/ui/Settings.tscn")
const ui_credits: PackedScene = preload("res://scenes/ui/Credits.tscn")
const lvl_0: PackedScene = preload("res://scenes/levels/lvl_0.tscn")
const lvl_1: PackedScene = preload("res://scenes/levels/lvl_1.tscn")
const lvl_2: PackedScene = preload("res://scenes/levels/lvl_2.tscn")
const lvl_3: PackedScene = preload("res://scenes/levels/lvl_3.tscn")
const lvl_4: PackedScene = preload("res://scenes/levels/lvl_4.tscn")
const lvl_5: PackedScene = preload("res://scenes/levels/lvl_5.tscn")
const lvl_6: PackedScene = preload("res://scenes/levels/lvl_6.tscn")
const lvl_7: PackedScene = preload("res://scenes/levels/lvl_7.tscn")
const lvl_8: PackedScene = preload("res://scenes/levels/lvl_8.tscn")
const lvl_9: PackedScene = preload("res://scenes/levels/lvl_9.tscn")

var master_audio_level: float = 0.4
var sfx_audio_level: float = 1.0
var music_audio_level: float = 0.0

var scores: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

# Notes for Aurora going into the 13th:
# You're working on what's currently level6
# It needs the train pokeballs stocked on some spawners
# It should also probably be moved down a bit because it's
# quite similar to the challenge of the curr level5
# Other than that, first thing tomorrow, DO THE TUTORIAL
# That's the key thing that's unfinished and uncuttable
# The other level idea you have is "Japan simulation"
# ie only high speed trains over long distances and limited
# corridors
# Also I saw a weird bug with trains just spontaneously combusting
# in the area. Probably look into that if it shows up again.
# I think that's all. Good night; sleep well!

enum TrainColor {
	RED,
	GREEN,
	YELLOW,
	BLUE
}

enum TrainType {
	HIGH_SPEED_PASSANGER,
	REGULAR_PASSANGER,
	CARGO,
	TRAM
}

enum CarriageType {
	CARGO_COAL,
	CARGO_ROCKS,
	CARGO_LUMBER,
	CARGO_OIL_RED,
	CARGO_OIL_YELLOW,
	CARGO_CRATE_RED,
	CARGO_CRATE_GREEN,
	CARGO_CRATE_BLUE,
	PASSANGER_RED,
	PASSANGER_YELLOW,
	PASSANGER_GREEN,
	HIGH_SPEED_BLUE,
}

enum SoundType {
	SFX,
	Music
}

var high_scores: Dictionary = {}

func load_level(level_name: String, to_remove: Node):
	to_remove.queue_free()
	get_tree().paused = false
	await get_tree().create_timer(0.005).timeout
	print("Loading level " + level_name)
	match level_name:
		"ui-main_menu":
			get_parent().add_child(ui_main_menu.instantiate())
		"ui-level_select":
			get_parent().add_child(ui_level_select.instantiate())
		"ui-settings":
			get_parent().add_child(ui_settings.instantiate())
		"ui-credits":
			get_parent().add_child(ui_credits.instantiate())
		"lvl_0":
			get_parent().add_child(lvl_0.instantiate())
		"lvl_1":
			get_parent().add_child(lvl_1.instantiate())
		"lvl_2":
			get_parent().add_child(lvl_2.instantiate())
		"lvl_3":
			get_parent().add_child(lvl_3.instantiate())
		"lvl_4":
			get_parent().add_child(lvl_4.instantiate())
		"lvl_5":
			get_parent().add_child(lvl_5.instantiate())
		"lvl_6":
			get_parent().add_child(lvl_6.instantiate())
		"lvl_7":
			get_parent().add_child(lvl_7.instantiate())
		"lvl_8":
			get_parent().add_child(lvl_8.instantiate())
		"lvl_9":
			get_parent().add_child(lvl_9.instantiate())
