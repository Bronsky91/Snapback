extends KinematicBody2D

export (int) var pat_speed = 50
export (int) var run_speed = 100
# This is what tells the enemy to change properties based on g.inverted
# e.g. Player is now invisible, switch sprite to base silhouette, etc
export (String, 'normal', 'inverted', 'both') var type = 'normal'

onready var pathfollow = get_parent()
onready var nav = get_node("/root/Game/Navigation2D")

var path : = PoolVector2Array()
var state: String = 'patrol'
var last_patrol_pos: Vector2 = position
var velocity = Vector2.ZERO
var player: KinematicBody2D = null

func _ready():
	pass # Replace with function body.

func _process(delta):
	if state == 'patrol':
		patrol(delta)
	if state == 'chase':
		if player:
			if player.safe:
				state = 'return'
			path = nav.get_simple_path(global_position, player.global_position)
			var move_distance = run_speed * delta
			move_along_path(move_distance)
			if path.size() == 0:
				# TODO: Since the player position is the end path and they collide
				# the enemy just pushes the player and never stops
				# this shouldn't be an issue once we start the game over but will need
				# extra logic around this code to make work
				state = 'return'
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.name == 'Player':
					pass
					# TODO: Restart game from last checkpoint
	if state == 'return':
		path = nav.get_simple_path(global_position, last_patrol_pos)
		var move_distance = run_speed * delta
		move_along_path(move_distance)
		if path.size() == 0:
			state = 'patrol'
			
func move_along_path(move_distance):
	while move_distance > 0 and path.size() > 0:
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
	pathfollow.offset += pat_speed * delta
	last_patrol_pos = global_position

func _on_DetectionArea_body_entered(body):
	if body.name == 'Player':
		player = body
		if not player.safe:
			state = 'chase'

func _on_DetectionArea_body_exited(body):
	if body.name == 'Player':
		player = null
		state = 'return'

func round_pos(pos: Vector2) -> Vector2:
	return Vector2(stepify(pos.x, 10), stepify(pos.y, 10))
