extends KinematicBody2D

export (int) var run_speed = 200
export (int) var sneak_speed = 100

var speed = run_speed
var item_count: int = 0
var velocity: Vector2 = Vector2()
var safe = false
var sneaking = false
var x_facing = "Right"
var x_changed = false
var y_facing = "Up"
var y_changed = false
var facing = "Right"
var animation = "Idle"
var new_facing = facing

onready var item_count_label = get_parent().get_node("CanvasLayer/ItemCountLabel")
onready var anim_player = $AnimationPlayer

func _ready():
	pass


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed("invert"):
		if new_facing == "Front" and velocity == Vector2(0, 0):
			anim_player.play('Inverse')
		toggle_inversion()
	
	if Input.is_action_just_pressed("crouch"):
		speed = sneak_speed
		sneaking = true
		g.emit_signal('sneak', true)
	if Input.is_action_just_released("crouch"):
		speed = run_speed
		sneaking = false
		g.emit_signal('sneak', false)
	
	# store necessary information to determine which way to face player in sprite_animation()
	# x axis
	x_changed = false
	if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
		x_facing = x_facing
	elif Input.is_action_pressed("right"):
		x_facing = "Right"
		x_changed = true
	elif Input.is_action_pressed("left"):
		x_facing = "Left"
		x_changed = true
	# y axis
	y_changed = false
	if Input.is_action_pressed("up") and Input.is_action_pressed("down"):
		y_facing = y_facing
	elif Input.is_action_pressed("up"):
		y_facing = "Back"
		y_changed = true
	elif Input.is_action_pressed("down"):
		y_facing = "Front"
		y_changed = true
	
	sprite_animation()


func sprite_animation():
	# If X and Y both changed, Y currently takes precedence
	if x_changed:
		new_facing = x_facing
	elif y_changed:
		new_facing = y_facing
		
	var new_animation = animation
	if velocity == Vector2(0,0) and sneaking:
		new_animation = "SneakIdle"
	elif velocity == Vector2(0,0) and not sneaking:
		new_animation = "Idle"
	elif velocity != Vector2(0,0) and sneaking:
		new_animation = "Sneak"
	elif velocity != Vector2(0,0) and not sneaking:
		new_animation = "Run"
	
	if new_facing != facing or new_animation != animation:
		facing = new_facing
		animation = new_animation
		anim_player.play(animation + facing)


func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func toggle_inversion():
	g.inverted = !g.inverted
	if g.inverted:
		$ColorRect.show()
		# change layer
		set_collision_layer_bit(3, false) # player_normal
		set_collision_layer_bit(4, true)  # player_inverted
		# change masks
		set_collision_mask_bit(1, false)  # walls_normal
		set_collision_mask_bit(2, true)   # walls_inverted
		set_collision_mask_bit(6, false)  # enemy_normal
		set_collision_mask_bit(7, true)   # enemy_inverted
	else:
		$ColorRect.hide()
		# change layer
		set_collision_layer_bit(3, true) # player_normal
		set_collision_layer_bit(4, false)  # player_inverted
		# change masks
		set_collision_mask_bit(1, true)  # walls_normal
		set_collision_mask_bit(2, false)   # walls_inverted
		set_collision_mask_bit(6, true)  # enemy_normal
		set_collision_mask_bit(7, false)   # enemy_inverted
	g.emit_signal('invert', g.inverted)


func _on_PickupArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == 'ItemArea':
		item_count = item_count + 1
		item_count_label.text = "Item Count: " + str(item_count)
		area.get_parent().queue_free()
	if area.name == 'SafeZoneArea':
		safe = true


func _on_PickupArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area and area.name == 'SafeZoneArea':
		safe = false
