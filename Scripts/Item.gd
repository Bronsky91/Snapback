extends Node2D


export(String, 'Watch', 'Coin', 'Inverted_Coin') var type = 'Coin'


func _ready():
	g.connect("invert", self, "_on_Player_invert")
	
	$Sprite.texture = load('res://Assets/' + type + '.png')
	
	if type == "Inverted_Coin":
		$Sprite.modulate.a = 0.2

func _on_Player_invert(inverted):
	if type == "Inverted_Coin":
		if inverted:
			$Sprite.modulate.a = 1
		else:
			$Sprite.modulate.a = 0.15
	else:
		if inverted:
			$Sprite.modulate.a = 0.15
		else:
			$Sprite.modulate.a = 1
	
