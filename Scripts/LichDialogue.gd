extends NinePatchRect

onready var boss_room = get_node('/root/BossRoom')
onready var voice_gen = $VoiceGeneratorAudioStreamPlayer

var is_talking = false
var skip = false
var current_dialogue_index = 0
var current_dialogue = [""]


var opening = [
	"Hue hue hue... just kidding, I'm deathless",
	"a little lich humor, for you",
	"So let's see what we got here"
]

func _ready():
	voice_gen.pitch_scale = 0.8


func start():
	var message = "You arrive at last..."
	$Name.bbcode_text = "???"
	$Message.bbcode_text = message
	self.visible = true
	voice_gen.read(message)


func uninvert():
	var message = "And not a moment too soon, I'm starving to death"
	$Name.bbcode_text = "Lucian L. Lich"
	$Message.bbcode_text = message
	voice_gen.read(message)


func opening_dialogue():
	var message = "And not a moment too soon, I'm starving to death"
	$Name.bbcode_text = "Lucian L. Lich"
	$Message.bbcode_text = message
	voice_gen.read(message)


func play_dialogue(arr):
	pass


func _input(event):
	if event.is_action_pressed("invert") and is_talking:
		skip = true


func _process(delta):
	is_talking = voice_gen.is_reading() and not voice_gen.is_waiting()
	if skip:
		voice_gen.read("")
		skip = false


func show_debug():
	$Name.bbcode_text = ""
	$Message.bbcode_text = ""
	$Debug.visible = true


func debug(t, s, c):
	g.final_score.time = t
	g.final_score.lost_slices = s
	g.final_score.coins = c
	print("debug_final_score")
	print(g.final_score)


func _on_debug_pressed():
	var c = $Debug/Coins.text
	var s = $Debug/Slices.text
	var t = $Debug/Time.text
	debug(t, s, c)
	$Debug.visible = false
