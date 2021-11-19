extends Node2D

var FL = preload("res://Scenes/FloatLabel.tscn")

export var text_travel: Vector2 = Vector2(0, -80)
export var text_duration: int = 2
export var text_spread: float = PI/2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func float_text(value):
	var ft = FL.instance()
	add_child(ft)
	ft.float_text(value, text_travel, text_duration, text_spread)
