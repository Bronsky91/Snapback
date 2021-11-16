extends StaticBody2D


export(int) var code = 1

var closed = true
var moving = false

func _ready():
	pass

func open_or_close_gate():
	if closed:
		$AnimationPlayer.play("GateOpen")
		closed = false
	else:
		$AnimationPlayer.play("GateClose")
		closed = true
	moving = true


func _on_AnimationPlayer_animation_finished(anim_name):
	moving = false
	if anim_name == 'GateOpen':
		$Locked.disabled = true
		$OpenLeft.disabled = false
		$OpenRight.disabled = false
	if anim_name == 'GateClose':
		$Locked.disabled = false
		$OpenLeft.disabled = true
		$OpenRight.disabled = true
