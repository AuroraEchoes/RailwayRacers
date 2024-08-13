extends CanvasLayer
class_name UIManager

@onready var time_remaining_label: Label = $MarginContainer/TimeRemainingContainer/TimeRemaining
@onready var time_remaining_timer: Timer = $MarginContainer/TimeRemainingContainer/TimeRemainingTimer
@onready var score_label: Label = $MarginContainer/ScoreContainer/Score
@onready var time_up_panel: PanelContainer = $MarginContainer/TimeUpPanel
@onready var level_lbl: Label = $MarginContainer/TimeUpPanel/MarginContainer/VBoxContainer/LevelNumber
@onready var score_lbl: Label = $MarginContainer/TimeUpPanel/MarginContainer/VBoxContainer/Score
@onready var play_again: Button = $MarginContainer/TimeUpPanel/MarginContainer/VBoxContainer/HBoxContainer/PlayAgain
@onready var back_to_menu: Button = $MarginContainer/TimeUpPanel/MarginContainer/VBoxContainer/HBoxContainer/BackToMenu
@onready var escape_menu_panel: PanelContainer = $MarginContainer/EscMenuPanel
@onready var resume_button: Button = $MarginContainer/EscMenuPanel/MarginContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $MarginContainer/EscMenuPanel/MarginContainer/VBoxContainer/ExitButton
@onready var level_info_panel: PanelContainer = $MarginContainer/LevelInfoPanel
@onready var level_info_num: Label = $MarginContainer/LevelInfoPanel/MarginContainer/VBoxContainer/LevelNumber
@onready var level_info_name: RichTextLabel = $MarginContainer/LevelInfoPanel/MarginContainer/VBoxContainer/LevelName

@export var round_time: float = 60.0
@export var level_number: int = 0
@export var level_name: String = "If you're seeing this, Aurora forgot to set the level name :("
var score: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	time_up_panel.hide()
	escape_menu_panel.hide()
	set_time_remaining(round_time)
	start_timer()
	time_remaining_timer.timeout.connect(_finish_level)
	play_again.pressed.connect(func(): Global.load_level("lvl_" + str(level_number), get_parent()))
	back_to_menu.pressed.connect(func(): Global.load_level("ui-main_menu", get_parent()))
	resume_button.pressed.connect(func(): 
		get_tree().paused = false
		time_remaining_timer.paused = false
		escape_menu_panel.hide()
	)
	exit_button.pressed.connect(func(): Global.load_level("ui-main_menu", get_parent()))
	_do_level_intro_text()

func _do_level_intro_text():
	level_info_panel.modulate.a = 0.0
	level_info_num.text = "Level " + str(level_number)
	level_info_name.text = level_name
	await get_tree().create_tween().tween_property(level_info_panel, "modulate:a", 1.0, 1.0).finished
	await get_tree().create_timer(5.0).timeout
	get_tree().create_tween().tween_property(level_info_panel, "modulate:a", 0.0, 1.0).finished

func _finish_level():
	get_tree().paused = true
	time_up_panel.show()
	level_lbl.text = "Level " + str(level_number)
	score_lbl.text = "Score: " + str(int(score))
	if level_number > 0:
		Global.scores[level_number - 1] = int(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time_remaining: float = time_remaining_timer.time_left
	time_remaining_label.text = _format_time(time_remaining)
	if time_remaining > 30.0:
		time_remaining_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	elif time_remaining < 10.0:
		time_remaining_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2, 1.0))
	elif time_remaining < 30.0:
		time_remaining_label.add_theme_color_override("font_color", Color(0.8, 0.6, 0.2, 1.0))
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		time_remaining_timer.paused = true
		escape_menu_panel.show()

func set_time_remaining(duration: float):
	time_remaining_timer.wait_time = duration
	 # 🕑 0:00 

func start_timer():
	time_remaining_timer.start()

func _format_time(time_remaining: float) -> String:
	var mins: int = floori(time_remaining / 60.0)
	var secs: int = ceili(time_remaining - (mins * 60.0))
	if secs == 60:
		mins += 1
		secs = 0
	var secs_str: String = str(secs)
	if secs < 10:
		secs_str = "0" + secs_str
	return "🕑 %s:%s " % [str(mins), secs_str]

func add_score(additional_score: float):
	score += additional_score
	score_label.text = "💲 " + str(int(score)) + " "
