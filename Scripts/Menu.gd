extends Node

var seconds = 0.0

var flip_intervals = [10.00, 40.50, 51.00, 71.50]
var reverse_intervals = [41.00, 72.00]

func _ready():
	pass 
	
func _input(event):
	if event.is_action_pressed('ui_accept'):
		get_tree().change_scene("res://Scenes/Game.tscn")
	if event.is_action_pressed("ui_cancel") and OS.window_fullscreen:
		OS.window_fullscreen = false


func _on_StartGame_button_up():
	$Main/AudioStreamPlayer.stop()
	yield(get_tree().create_timer(.5), "timeout")
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Inverse":
		$Main/Pizzaboy/AnimationPlayer.play("IdleReverse")
	else:
		$Main/Pizzaboy/AnimationPlayer.play("Idle")


func _on_Timer_timeout():
	seconds = seconds + 0.5
	if flip_intervals.has(seconds):
		flip_it()
	if reverse_intervals.has(seconds):
		$Main/CanvasLayer/InvertScreen.visible = false
	if seconds == 41.00:
		$Main/Pizzaboy/LichEyes/AnimationPlayer.play("LichEyeBounce")
	if seconds ==  77.0:
		seconds = 0

func flip_it():
	var animation_name = 'Inverse' if not $Main/CanvasLayer/InvertScreen.visible else 'Reverse'
	$Main/Pizzaboy/AnimationPlayer.play(animation_name)
	if animation_name == 'Inverse':
		$Main/CanvasLayer/InvertScreen.visible = true


func _on_Button_button_up():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_SplashTimer_timeout():
	$SplashScreen.hide()
	$Main.show()
	$Main/CanvasLayer/StartGame.show()
