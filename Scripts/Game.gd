extends Node

onready var pizza_timer: Timer = get_node("PizzaTimer")
onready var pizza_timer_label: RichTextLabel = get_node("UI/PizzaTimerLabel")
onready var shockwave: ColorRect = get_node("UI/Shockwave")
onready var shockwave_player: AnimationPlayer = get_node("UI/Shockwave/AnimationPlayer")
onready var coin_count_label: RichTextLabel = get_node("UI/CoinCount")

var pizza_time = 1800 # 1800 seconds in 30 min

var coin_count = 0

func _ready():
	pizza_timer.start()
	pizza_timer_label.bbcode_text = "30:00"
	coin_count_label.bbcode_text = str(coin_count)

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

func add_coin():
	coin_count += 1
	coin_count_label.bbcode_text = str(coin_count)

func shockwave(inverted):
	shockwave.visible = true
	if inverted:
		shockwave_player.play("invert")
	else:
		shockwave_player.play("normal")


func _on_AnimationPlayer_animation_finished(anim_name):
	shockwave.visible = false
