extends KinematicBody2D

export (int) var run_speed = 200
export (int) var sneak_speed = 100

onready var item_count_label = get_parent().get_node("CanvasLayer/ItemCountLabel")

var speed = run_speed
var item_count: int = 0
var velocity: Vector2 = Vector2()
var safe = false

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
		toggle_inversion()
	
	if Input.is_action_just_pressed("crouch"):
		speed = sneak_speed
		#g.sneaking = true
		g.emit_signal('sneak', true)
	if Input.is_action_just_released("crouch"):
		speed = run_speed
		g.emit_signal('sneak', false)
		#g.sneaking = false

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func toggle_inversion():
	g.inverted = !g.inverted
	if g.inverted:
		set_collision_layer_bit(3, false)
		set_collision_layer_bit(4, true)
		$ColorRect.show()
	else:
		set_collision_layer_bit(3, true)
		set_collision_layer_bit(4, false)
		$ColorRect.hide()


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
