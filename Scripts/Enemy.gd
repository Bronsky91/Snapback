extends KinematicBody2D

export (String, "loop", "linear") var patrol_type = "linear"
export (int) var pat_speed = 50
export (int) var run_speed = 100

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
			velocity = global_position.direction_to(player.global_position) * run_speed
			velocity = move_and_slide(velocity)
	if state == 'return':
		velocity = global_position.direction_to(last_patrol_pos) * run_speed
		velocity = move_and_slide(velocity)
		if round_pos(global_position) == round_pos(last_patrol_pos):
			state = 'patrol'

func patrol(delta):
	if patrol_type == 'loop':
		pathfollow.offset += pat_speed * delta
		last_patrol_pos = global_position

func _on_DetectionArea_body_entered(body):
	if body.name == 'Player':
		player = body
		state = 'chase'

func _on_DetectionArea_body_exited(body):
	print(body.name)
	if body.name == 'Player':
		player = null
		state = 'return'

func round_pos(pos: Vector2) -> Vector2:
	return Vector2(stepify(pos.x, 10), stepify(pos.y, 10))
