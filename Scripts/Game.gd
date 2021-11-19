extends Node

onready var pizza_timer: Timer = get_node("PizzaTimer")
onready var pizza_timer_label: RichTextLabel = get_node("UI/PizzaTimerLabel")
onready var shockwave: ColorRect = get_node("UI/Shockwave")
onready var shockwave_player: AnimationPlayer = get_node("UI/Shockwave/AnimationPlayer")

var pizza_time = 1800 # 1800 seconds in 30 min

func _ready():
	pizza_timer.start()
	pizza_timer_label.bbcode_text = "30:00"


#func _process(delta):
#	pass

func format_time():
	return str(abs(ceil(pizza_time/60))).pad_zeros(2) + ":" + str("%01d" % abs(ceil(pizza_time % 60))).pad_zeros(2)
	
# .5 seconds is 1 second in game
func _on_PizzaTimer_timeout():		
	pizza_time -= 1
	if pizza_time < 0:
		pizza_timer_label.bbcode_text = '[color=red] - ' + format_time()
	else:
		pizza_timer_label.bbcode_text = format_time()

func reset_pizza_time():
	pizza_time = 1800
	pizza_timer_label.bbcode_text = "30:00"

func add_time():
	pizza_time += 120
	pizza_timer_label.bbcode_text = format_time()


func shockwave():
	shockwave.visible = true
	shockwave_player.play("Shockwave")


func _on_AnimationPlayer_animation_finished(anim_name):
	shockwave.visible = false
