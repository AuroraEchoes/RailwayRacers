extends Node3D
class_name Explosion

func _ready():
	$ExplosionSound.play()
	$Sparkles.emitting = true
	$Flash.emitting = true
	$Fire.emitting = true
	$Smoke.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
