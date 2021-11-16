extends StaticBody2D


export(String, 'top', 'bottom', 'left', 'right') var wall_direction
export(String, 'normal', 'invert') var wall_realm


# Called when the node enters the scene tree for the first time.
func _ready():
	print('wall_realm: ' + wall_realm)
	if wall_realm == 'normal':
		print('setting layer 3')
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(2, true)
		#set_collision_layer_bit(2, false)
		#set_collision_mask_bit(2, false)
	else:
		print('setting layer 2')
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(1, true)
		#set_collision_layer_bit(3, false)
		#set_collision_mask_bit(3, false)

func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		modulate = Color(1, 1, 1, .5)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		modulate = Color(1, 1, 1, 1)
