extends KinematicBody2D

export (int) var pat_speed = 50
export (int) var run_speed = 120
export (int) var vision_range = 80
export (int) var alert_range = 120
export (String, 'Left', 'Right', 'Front', 'Back') var default_facing = 'Front'

onready var pathfollow = get_parent()
onready var nav = get_node("/root/Game/Navigation2D")
onready var sfx: AudioStreamPlayer2D = $SFX
onready var sprite = $Sprite
onready var shadow = $Shadow
onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast2D
onready var detection_shape = $DetectionArea/CollisionShape2D
onready var alert_shape = $AlertArea/CollisionShape2D
onready var eyes = $Eyes
onready var hands = $Hands
onready var exclamation = $Exclamation

var path : = PoolVector2Array()
var state: String = 'patrol'
var last_patrol_pos: Vector2
var velocity = Vector2.ZERO
var player: KinematicBody2D = null
var player_sneaking = false
var facing = "Right"
var not_patroling = false

func _ready():
	detection_shape.shape.radius = vision_range
	alert_shape.shape.radius = alert_range
		
	last_patrol_pos = global_position
	not_patroling = not pathfollow is PathFollow2D
	g.connect("sneak", self, "_on_Player_sneak")
	g.connect("invert", self, "_on_Player_invert")
	g.connect("go_home", self, "_on_Player_damaged")
	
	invert(g.inverted)
	


func _process(delta):
	if state == 'patrol':
		if not_patroling:
			anim_player.play('Idle' + default_facing)
		else:
			patrol(delta)
	if state == 'chase':
		eyes.visible = false
		hands.visible = false
		if player:
			if player.safe:
				hide_icons()
				state = 'return'
			path = nav.get_simple_path(global_position, player.global_position)
			var move_distance = run_speed * delta
			move_along_path(move_distance)
			if path.size() == 0:
				# Shouldn't get to path 0, but as a safeguard end chase if it does happen
				state = 'return'
	if state == 'return':
		path = nav.get_simple_path(global_position, last_patrol_pos)
		var move_distance = run_speed * delta
		move_along_path(move_distance)
		if path.size() == 0:
			state = 'patrol'


func _physics_process(delta):
	if player and state != "chase":
		chase_check()


func move_along_path(move_distance):
	while move_distance > 0 and path.size() > 0:
		for p in range(5, -1, -1):
			if path.size() > p:
				animate_sprite(global_position, path[p])
				break
		var distance_to_next_point = global_position.distance_to(path[0])
		if move_distance <= distance_to_next_point:
			# The enemy does not have enough movement left to get to the next point.
			global_position += global_position.direction_to(path[0]) * move_distance
		else:
			# The enemy get to the next point
			global_position = path[0]
			path.remove(0)
		# Update the distance to walk
		move_distance -= distance_to_next_point


func patrol(delta):
	# Move enemy along patrol path
	pathfollow.offset += pat_speed * delta
	animate_sprite(last_patrol_pos, global_position)
	
	# Prepare last patrol pos for next cycle
	last_patrol_pos = global_position


func animate_sprite(from, to):
	# Determine which way to face enemy based on prior position
	var dir = from.direction_to(to)
	var dominant_axis = "x" if abs(dir.x) > abs(dir.y) else "y"
	var new_facing = facing
	if dominant_axis == "x":
		new_facing = "Right" if dir.x > 0 else "Left"
	else:
		new_facing = "Front" if dir.y > 0 else "Back"
	
	if not_patroling:
		anim_player.play("Walk" + new_facing)
		
	# Animate enemy in appropriate direction
	if facing != new_facing:
		facing = new_facing
		if "Ghost" in name:
			anim_player.play(name + facing)
		if name == "Skeleton" or name == "GrimReaper":
			anim_player.play("Walk" + facing)

func _on_DetectionArea_body_entered(body):
	if body.name == 'Player':
		player = body
		chase_check()


func _on_DetectionArea_body_exited(body):
	if body.name == 'Player' and not name == 'GrimReaper':
		player = null
		hide_icons()
		state = 'return'


func chase_check():
	if player and not player.safe and not player.is_invulnerable:
		var direction_to_player = global_position.direction_to(player.global_position)
		raycast.cast_to = direction_to_player * vision_range
		raycast.force_raycast_update()
		var collision_object = raycast.get_collider()
		if collision_object == player:
			show_icon("exclamation")
			state = "chase"
			play_minion_chase()

func _on_Player_sneak(sneaking):
	if sneaking:
		$DetectionArea/CollisionShape2D.scale.x = 0.5
		$DetectionArea/CollisionShape2D.scale.y = 0.5
		# Update to squinty eyes
		$Eyes.texture = load('res://Assets/eyes2.png')
	else:
		$DetectionArea/CollisionShape2D.scale.x = 1
		$DetectionArea/CollisionShape2D.scale.y = 1
		# Update to open eyes
		$Eyes.texture = load('res://Assets/eyes.png')


func _on_Player_invert(inverted):
	invert(inverted)


func _on_Player_damaged(attacker):
	if state == "chase":
		player = null
		if attacker == self:
			pizza_thief()
		else:
			hide_icons()
		state = "return"


func invert(inverted):
	# If player is on opposite inversion of enemy, replace enemy sprite with shadow
	if (inverted and get_collision_layer_bit(6)) or (!inverted and get_collision_layer_bit(7)):
		sprite.visible = false
		shadow.visible = true
		hide_icons()
	else:
		sprite.visible = true
		shadow.visible = false


func round_pos(pos: Vector2) -> Vector2:
	return Vector2(stepify(pos.x, 10), stepify(pos.y, 10))


func _on_AlertArea_body_entered(body):
	if body.name == 'Player':
		play_minion_aware()
		show_icon("eyes")


func _on_AlertArea_body_exited(body):
	if body.name == 'Player':
		eyes.visible = false

func play_minion_chase():
	sfx.stream = load("res://Assets/Audio/minion_pizza.mp3")
	sfx.play()

func play_minion_aware():
	# ~1 in 5 chance to play stomach growl
	if randi() % 100 < 20:
		sfx.stream = load("res://Assets/Audio/stomach_growl.mp3")
		sfx.play()


# For when the enemy snatches a slice
func pizza_thief():
	show_icon("hands")
	$HandsTimer.start()


func show_icon(icon):
	hide_icons()
	if icon == "eyes":
		eyes.visible = true
	elif icon == "hands":
		hands.visible = true
	elif icon == "exclamation":
		exclamation.visible = true

func hide_icons():
	eyes.visible = false
	exclamation.visible = false


func _on_HandsTimer_timeout():
	hands.visible = false
