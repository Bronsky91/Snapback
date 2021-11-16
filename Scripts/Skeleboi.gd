extends AnimatedSprite

onready var dialogue_player = get_node('/root/Game/UI/DialoguePlayer')

var player_present = false
var dialog_open = false

func _ready():
	pass 
	
	
func _input(event):
	if event.is_action_pressed("interact") and player_present:
		if dialog_open:
			dialogue_player.hide()
			dialog_open = false
		else:
			find_and_use_dialogue()
		
		
func find_and_use_dialogue():
	dialogue_player.play()
	dialog_open = true


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player_present = true


func _on_Area2D_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player_present = false
		dialogue_player.hide()
		dialog_open = false
