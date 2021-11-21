extends StaticBody2D


export(int) var code = 1

var closed = true
var moving = false

func _ready():
	pass

func open_gate():
	if closed:
		$AnimationPlayer.play("GateOpen")
		closed = false
	moving = true


func _on_AnimationPlayer_animation_finished(anim_name):
	moving = false
	if anim_name == 'GateOpen':
		$Locked.disabled = true
		$OpenLeft.disabled = false
		$OpenRight.disabled = false
