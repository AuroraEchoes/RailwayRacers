extends AudioStreamPlayer3D

@export var sound_type: Global.SoundType = Global.SoundType.SFX
@export var relative_volume: float = 1.0

func _process(_delta):
	var percent_volume: float = Global.master_audio_level * relative_volume
	match sound_type:
		Global.SoundType.SFX:
			percent_volume *= Global.sfx_audio_level
		Global.SoundType.Music:
			percent_volume *= Global.music_audio_level
	self.volume_db = lerp(-20.0, 20.0, percent_volume)
	if percent_volume == 0.0:
		self.volume_db = -1000.0
