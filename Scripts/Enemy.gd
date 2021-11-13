extends KinematicBody2D

export (int) var pat_speed = 50
export (int) var run_speed = 100
# This is what tells the enemy to change properties based on g.inverted
# e.g. Player is now invisible, switch sprite to base silhouette, etc
export (String, 'normal', 'inverted', 'both') var type = 'normal'

onready var pathfollow = get_parent()

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
			velocity = global_position.direction_to(player.global_position) * run_speed
			velocity = move_and_slide(velocity)
			for i in get_slide_count():
				var collision = get_slide_collision(i)
				if collision.collider.name == 'Player':
					pass
					# TODO: Restart game from last checkpoint
	if state == 'return':
		velocity = global_position.direction_to(last_patrol_pos) * run_speed
		velocity = move_and_slide(velocity)
		if round_pos(global_position) == round_pos(last_patrol_pos):
			state = 'patrol'

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
