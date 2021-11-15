extends Node

onready var pizza_timer: Timer = get_node("PizzaTimer")
onready var pizza_timer_label: Label = get_node("UI/PizzaTimerLabel")

var pizza_time = 1800 # 1800 seconds in 30 min

func _ready():
	pizza_timer.start()
	pizza_timer_label.text = "30:00"


#func _process(delta):
#	pass

func format_time():
	return str(ceil(pizza_time/60)).pad_zeros(1) + ":" + str(ceil(pizza_time % 60)).pad_zeros(1)
	
# .5 seconds is 1 second in game
func _on_PizzaTimer_timeout():
	pizza_time -= 1 
	pizza_timer_label.text = format_time()

func reset_pizza_time():
	pizza_time = 1800
	pizza_timer_label.text = "30:00"
