extends Node

var seconds = 0.0

var flip_intervals = [10.00, 40.50, 51.00, 71.50]
var reverse_intervals = [41.00, 72.00]

func _ready():
	pass 
	
func _input(event):
	if event.is_action_pressed('ui_accept'):
		get_tree().change_scene("res://Scenes/Game.tscn")


func _on_StartGame_button_up():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Inverse":
		$Pizzaboy/AnimationPlayer.play("IdleReverse")
	else:
		$Pizzaboy/AnimationPlayer.play("Idle")


func _on_Timer_timeout():
	seconds = seconds + 0.5
	if flip_intervals.has(seconds):
		flip_it()
	if reverse_intervals.has(seconds):
		$CanvasLayer/InvertScreen.visible = false
	if seconds == 41.00:
		$Pizzaboy/LichEyes/AnimationPlayer.play("LichEyeBounce")
	if seconds ==  77.0:
		seconds = 0

func flip_it():
	var animation_name = 'Inverse' if not $CanvasLayer/InvertScreen.visible else 'Reverse'
	$Pizzaboy/AnimationPlayer.play(animation_name)
	if animation_name == 'Inverse':
		$CanvasLayer/InvertScreen.visible = true


func _on_StartGame_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

