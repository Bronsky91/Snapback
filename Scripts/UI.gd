extends CanvasLayer

onready var child_nodes = get_children()

func _ready():
	g.connect("invert", self, "_on_Player_Invert")


func _on_Player_Invert(inverted):
	if inverted:
		for n in child_nodes:
			if n is Label:
				n.add_color_override("font_color", Color(0,0,0))
	else:
		for n in child_nodes:
			if n is Label:
				n.add_color_override("font_color", Color(1,1,1))
