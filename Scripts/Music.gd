extends AudioStreamPlayer

func _ready():
	g.connect("invert", self, "_on_Player_invert")
	invert(g.inverted)


func _on_Player_invert(inverted):
	invert(inverted)


func invert(inverted):
	# reverse background theme when inverted
	if inverted:
		self.stream = load("res://Assets/Audio/reverse_theme.mp3")
		self.play()
	else:
		self.stream = load("res://Assets/Audio/theme.mp3")
		self.play()
