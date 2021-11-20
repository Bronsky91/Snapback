extends Node

var seconds = 0

var flip_intervals = [10, 41, 51, 72]


func _ready():
	pass 


func _on_StartGame_button_up():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Inverse":
		$Pizzaboy/AnimationPlayer.play("IdleReverse")
	else:
		$CanvasLayer/InvertScreen.visible = false
		$Pizzaboy/AnimationPlayer.play("Idle")


func _on_Timer_timeout():
	seconds = seconds + 1
	if flip_intervals.has(seconds):
		flip_it()

func flip_it():
	var animation_name = 'Inverse' if not $CanvasLayer/InvertScreen.visible else 'Reverse'
	$Pizzaboy/AnimationPlayer.play(animation_name)
	$CanvasLayer/InvertScreen.visible = animation_name == 'Inverse'


func _on_StartGame_pressed():
	print('hi')
	get_tree().change_scene("res://Scenes/Game.tscn")
