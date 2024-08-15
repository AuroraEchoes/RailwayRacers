extends Camera3D

const MAX_ZOOM = 5
const MIN_ZOOM = 80
const PAN_SPEED = 3.0
const TIME_TO_MAX_PAN = 60 # 60 frames to hit top speed
const MAX_DIST_FROM_ORIGIN = 25.0
const ACTIONS = ["pan_left", "pan_right", "pan_up", "pan_down"]

var panning: Array[int] = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_pan()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action("zoom_in") or Input.is_action_just_released("ui_text_scroll_down.macos"):
			self._zoom(-10.0)
		elif event.is_action("zoom_out") or Input.is_action_just_pressed("ui_text_scroll_up.macos"):
			self._zoom(10.0)

func _zoom(factor: float):
	var rotation_percent: float = abs(self.rotation_degrees.x) / 90.
	# Is this the good way? No
	# Is this the easy way? Yes!
	if position.y + (factor * rotation_percent) < MAX_ZOOM and factor < 0.0:
		return
	elif position.y + (factor * rotation_percent) > MIN_ZOOM and factor > 0.0:
		return
	var delta: Vector3 = Vector3(0., rotation_percent * factor, (1 - rotation_percent) * factor)
	position += delta
	var tween: Tween = self.create_tween()
	tween.tween_property(self, "position", position + delta, 0.25)

func _pan():
	for i in range(4):
		if Input.is_action_just_pressed(ACTIONS[i]):
			panning[i] += 1
		elif Input.is_action_just_released(ACTIONS[i]):
			panning[i] = 0
		if panning[i] > 0:
			panning[i] += 1
	
	var amount: Vector2 = Vector2.LEFT * _pan_ease(panning[0]) + Vector2.RIGHT * _pan_ease(panning[1]) + Vector2.UP * _pan_ease(panning[2]) + Vector2.DOWN * _pan_ease(panning[3])
	var tween: Tween = self.create_tween()
	var new_pos: Vector3 = (Vector3(amount.x, 0, amount.y) * PAN_SPEED) + position
	tween.tween_property(self, "position", new_pos, 0.25)

func _pan_ease(progress: int) -> float:
	return bool(progress > 0)
