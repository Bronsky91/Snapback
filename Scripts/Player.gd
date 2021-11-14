extends KinematicBody2D

export (int) var run_speed: int = 200
export (int) var sneak_speed: int = 100

onready var anim_player: AnimationPlayer = $AnimationPlayer

onready var player_start_node: Position2D = get_parent().get_node("PlayerStart")
onready var inverse_mana_bar: TextureProgress = get_parent().get_node("CanvasLayer/InverseManaBar")
onready var mana_bar_label: Label = get_parent().get_node("CanvasLayer/ManaBarLabel")
onready var life_count_label: Label = get_parent().get_node("CanvasLayer/LifeCountLabel")

var life_count: int = 3
var speed: int = run_speed
var item_count: int = 0 # TODO: Refactor this, item_count has no purpose
var velocity: Vector2 = Vector2()
var safe: bool = false
var sneaking: bool = false
var inverse_ready: bool = true
var inverse_mana: int = 100
var last_checkpoint_pos: Vector2 = Vector2()

var x_facing: String = "Right"
var x_changed: bool = false
var y_facing: String = "Up"
var y_changed: bool = false
var facing: String = "Right"
var animation: String = "Idle"
var new_facing: String = facing


func _ready():
	print(inverse_mana_bar)
	inverse_mana_bar.value = inverse_mana
	mana_bar_label.text = str(inverse_mana) + '%'
	last_checkpoint_pos = player_start_node.global_position
	life_count_label.text = "Lives: " + str(life_count)


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
		if inverse_ready:
			toggle_inversion(velocity)
	
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


func toggle_inversion(velocity):
	if new_facing == "Front" and velocity == Vector2(0, 0):
		anim_player.play('Inverse')
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
	inverse_ready = false
	$InverseCooldown.start()
	if inverse_mana >= 20:
		inverse_mana -= 20
		inverse_mana_bar.value -= 20
		mana_bar_label.text = str(inverse_mana) + '%'
	
func attacked():
	print('player is being attacked')
	if life_count == 1:
		# Game over
		global_position = player_start_node.global_position
		# TODO: Reset any relevant state here
		life_count = 3
	else:
		life_count -= 1
		global_position = last_checkpoint_pos
	life_count_label.text = "Lives: " + str(life_count)

func _on_PickupArea_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == 'ItemArea':
		item_count = item_count + 1
		area.get_parent().queue_free()
	if area.name == 'SafeZoneArea':
		safe = true
		# TODO: Show floating text telling the player they've got to a checkpoint?
		last_checkpoint_pos = area.global_position

func _on_PickupArea_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area and area.name == 'SafeZoneArea':
		safe = false

func _on_InverseCooldown_timeout():
	inverse_ready = true

func _on_ManaIncreaseTimer_timeout():
	if inverse_mana < 100:
		inverse_mana += 1
		inverse_mana_bar.value += 1
		mana_bar_label.text = str(inverse_mana) + '%'
