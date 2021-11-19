extends Node2D


export(String, 'Watch', 'Coin') var type = 'Watch'


func _ready():
	$Sprite.texture = load('res://Assets/' + type + '.png')


