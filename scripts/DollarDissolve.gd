extends Node3D
class_name DollarDissolve

func _ready():
	$Dollars.emitting = true
	await get_tree().create_timer(1.2).timeout
	queue_free()
