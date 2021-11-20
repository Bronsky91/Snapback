extends NinePatchRect

func _ready():
	$VoiceGeneratorAudioStreamPlayer.pitch_scale = 0.8


func start():
	var message = "You arrive at last..."
	$Name.bbcode_text = "???"
	$Message.bbcode_text = message
	self.visible = true
	$VoiceGeneratorAudioStreamPlayer.read(message)


func concat_arrays(arr1, arr2):
	arr1 += arr2
	return arr1
