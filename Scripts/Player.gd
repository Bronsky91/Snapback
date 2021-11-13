extends KinematicBody2D

export (int) var speed = 200

onready var item_count_label = get_parent().get_node("CanvasLayer/ItemCountLabel")

var item_count: int = 0
var velocity: Vector2 = Vector2()
var safe = false

func _ready():
	print(item_count_label)
	
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

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

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
