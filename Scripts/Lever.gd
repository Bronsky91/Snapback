extends Node2D


export(int) var gate_code = 1

var player = null

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("interact") and player:
		var gates = get_tree().get_nodes_in_group('gates')
		for gate in gates:
			if gate.code == gate_code and not gate.moving:
				gate.open_or_close_gate()
				$LeverSprite.play('default', $LeverSprite.frame == 2)
				var gate_sound = 'close_gate' if gate.closed else 'open_gate'
				player.play_sfx(gate_sound)


func _on_InteractionArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player = area.get_parent()


func _on_InteractionArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player = null


func _on_LeverSprite_frame_changed():
	if $LeverSprite.frame == 2 or $LeverSprite.frame == 0:
		$LeverSprite.stop()
