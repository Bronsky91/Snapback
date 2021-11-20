extends AnimatedSprite

onready var dialogue_player = get_node('/root/Game/UI/DialoguePlayer')

export(String, "in danger", "free", "painter") var skelly_status = "in danger"
export(String) var skelly_name
export(String) var skelly_text

var player_present = false
var dialog_open = false
var talked_to = false

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
	print(g.final_score['skellies_talked_to'])
	dialogue_player.skele_play(skelly_status, skelly_name, skelly_text)
	dialog_open = true
	$AudioStreamPlayer2D.play()
	if not talked_to:
		talked_to = true
		g.final_score['skellies_talked_to'] = g.final_score['skellies_talked_to'] + 1


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area and area.get_parent().name == "Player":
		player_present = true


func _on_Area2D_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area and area.get_parent().name == "Player":
		player_present = false
		dialogue_player.hide()
		dialog_open = false
