extends Control

onready var text_nodes = get_children()

func _ready():
	g.connect("invert", self, "_on_Player_Invert")
	
	
func _on_Player_Invert(inverted):
	if inverted:
		for n in text_nodes:
			n.add_color_override("default_color", Color(0,0,0))
	else:
		for n in text_nodes:
			n.add_color_override("default_color", Color(1,1,1))
