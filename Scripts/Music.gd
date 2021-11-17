extends AudioStreamPlayer

export (int) var track_length = 48

func _ready():
	g.connect("invert", self, "_on_Player_invert")
	invert(g.inverted)


func _on_Player_invert(inverted):
	invert(inverted)


func invert(inverted):
	# reverse background music
	var playback_pos = self.get_playback_position()
	var reversed_pos = track_length - playback_pos if track_length - playback_pos >= 0 else 0
	
	if inverted:
		self.stream = load("res://Assets/Audio/dungeon_theme_reverse.mp3")
		self.play(reversed_pos)
	else:
		self.stream = load("res://Assets/Audio/dungeon_theme.mp3")
		self.play(reversed_pos)

