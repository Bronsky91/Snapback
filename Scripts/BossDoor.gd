extends Node2D

onready var game_scene: Node = get_node('/root/Game')

var player = null

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("interact") and player:
		game_scene.clock_running = false
		g.final_score.coins = game_scene.coin_count
		g.final_score.time = game_scene.pizza_time
		if game_scene.pizza_time < 0:
			g.final_score.timestamp = '- ' + game_scene.format_time()
		else:
			g.final_score.timestamp = game_scene.format_time()
		g.final_score.slices_lost = player.slices_lost
		g.final_score.inversions = player.inversion_count
		
		player.play_sfx('open_gate')
		SceneChanger.change_scene("res://Scenes/BossRoom.tscn", 0.5)


func _on_InteractionArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player = area.get_parent()


func _on_InteractionArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.get_parent().name == "Player":
		player = null
