extends Node

onready var pizza_timer: Timer = get_node("PizzaTimer")
onready var pizza_timer_label: RichTextLabel = get_node("UI/PizzaTimerLabel")
onready var shockwave: ColorRect = get_node("UI/Shockwave")
onready var shockwave_player: AnimationPlayer = get_node("UI/Shockwave/AnimationPlayer")
onready var coin_count_label: RichTextLabel = get_node("UI/CoinCount")

var pizza_time = 1800 # 1800 seconds in 30 min
var clock_running = true
var coin_count = 0
var free_pizza = false

func _ready():
	pizza_timer.start()
	pizza_timer_label.bbcode_text = "30:00"
	coin_count_label.bbcode_text = str(coin_count)

func format_time():
	return str(abs(ceil(pizza_time/60))).pad_zeros(2) + ":" + str("%01d" % abs(ceil(pizza_time % 60))).pad_zeros(2)


func respawn():
	$UI/ScreenWipe.visible = true
	$UI/ScreenWipe/ScreenWipePlayer.play("circle_fade_in")	


# .25 seconds is 1 second in game
func _on_PizzaTimer_timeout():
	if clock_running:
		pizza_time -= 1
		if pizza_time < 0:
			pizza_timer_label.bbcode_text = '[color=red] - ' + format_time()
			if not free_pizza:
				free_pizza = true
				$SFX.stream = load("res://Assets/Audio/lich_stomach_growl.mp3")
				$SFX.play()
				g.emit_signal('shake', 3, 18, 18, 0)
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
	if inverted:
		shockwave_player.play("invert")
	else:
		shockwave_player.play("normal")
	shockwave.visible = true


func _on_AnimationPlayer_animation_finished(anim_name):
	shockwave.visible = false


func _on_ScreenWipePlayer_animation_finished(anim_name):
	if anim_name == "circle_fade_in":
		$UI/ScreenWipe/ScreenWipePlayer.play("circle_fade_out")
	elif anim_name == "circle_fade_out":
		$UI/ScreenWipe.visible = false
