extends NinePatchRect

onready var boss_room = get_node('/root/BossRoom')
onready var voice_gen = $VoiceGeneratorAudioStreamPlayer

var is_talking = false
var current_dialogue_index = 0
var current_dialogue = [""]
var minutes = str(abs(ceil(g.final_score.time/60))).pad_zeros(2)
var line_index = 0
var interactive_dialogue = false
var can_next_line = false

var time_good = [
	"Wow… you actually got here in " + minutes + " minutes….. (I’ll have to talk to my guards…)",
	"Wait, I wasn’t expecting you for another " + str(30 - int(minutes)) + " minutes! Marvelous! Wait here and I will get… YOUR REWARD! HAHAHAHA!",
	"Wow, this is actually still hot! You were quick, human. Here’s your tip.  Now leave me! I have some unfinished business with this cheesy pie!",
	"How did you get here so fast? Did you find my ghost wall secret bypass tunnel?! Er… I mean, nevermind- Thanks for the Pizza, mortal!",
]
var time_bad = [
	"Heh. It’s been longer than 30 minutes. The pizza is free.",
	"Seriously?! You couldn’t have taken more time if you had sneaked the whole way… Very, very disappointing",
	"Can’t you see how hungry I am? And still you try my patience. You will pay for your lateness, and I will not be paying for this pizza!",
	"I had ordered that  so long ago, I had forgotten I even placed the order. I guess cold pizza is ok, but i won’t be ordering from you anymore, enjoy your journey home human",
]
var slices_good = [
	"So beautiful, So cheesy, not one slice missing! I am pleased, mortal. Now for your reward HAHAHAHA",
	"I don’t know what is harder to believe, that you are in one piece or that you managed to get my pizza though all of my minions without losing any of that ooey gooey goodness! Keep the change!",
	"Excellent, I figured I would have a slice or two for myself, but I didn’t expect you’d get that hot baked za to me without any pieces stolen, very impressive",
]
var slices_bad = [
	"Why is half of my pizza missing?",
	"Wait a minute, Where’s the rest of my pizza?! If you think I'm going to pay full price for a less than full pie, you’re wrong. Leave the pie and get out of my sight!",
	"If you hadn’t lost so much of my delicious pizza to my minions, I might have been willing to tip a little better. your loss, mortal.",
	"My baby! What have you done to my precious cheesy baby!? My pizza is ruined and now you will pay!",
]
var coins_good = [
	"Oh wonderful! Just let me get my wallet… uh oh, I swear I had all my coins in here, but it looks like there is a hole in the bottom… Will you take a card?",
	"Ah I can hear from the jingle of your pockets that you found the tip I left for you! I’m glad your greed ushered you to my chambers with such haste!",
	"HAHAHA, you’ve found all of my gold and now I get all of your gold… Golden deliciously good pizza that is! Well done mortal!",
]
var coins_bad = [
	"You only collected " + str(g.final_score.coins) + " coins? That was your tip. No worries, you get what you deserve.",
	"So scared of my minions you didn’t bother to grab your tip, a pity…",
	"I hope you grabbed enough coin to pay the ferryman back across the river Styx? No? Well then best make yourself comfortable HAHAHAHAHA!",
	"Seems like this pizza is on the house. It’s not my fault if you failed to grab the tip I left out for you. Goodbye, mortal.",
]

var lines = []


func _ready():
	voice_gen.pitch_scale = 0.8
	lines = [
		"...",
		time_good[randi() % time_good.size()] if g.final_score.time >= 0 else time_bad[randi() % time_bad.size()],
		"...",
		slices_good[randi() % slices_good.size()] if g.final_score.slices_lost < 4 else slices_bad[randi() % slices_bad.size()],
		"...",
		coins_good[randi() % coins_good.size()] if g.final_score.coins >= 100 else coins_bad[randi() % coins_bad.size()],
	]


func play_message(msg):
	self.visible = true
	$Message.bbcode_text = msg
	voice_gen.read(msg)

func start():
	$Name.bbcode_text = "???"
	play_message("Well well well, you arrive at last...")


func laugh():
	play_message("Oh ho ho...")


func judgement():
	$Name.bbcode_text = "Lucian L. Lich"
	play_message(lines[line_index])
	interactive_dialogue = true
	start_idle_timer()


func next_line():
	$E.visible = false
	line_index += 1
	if line_index >= lines.size():
		interactive_dialogue = false
		self.visible = false
		boss_room.high_score()
	else:
		play_message(lines[line_index])
		start_idle_timer()


func _input(event):
	if interactive_dialogue and event.is_action_pressed("interact"):
		voice_gen.read("")
		if can_next_line:
			next_line()


func _on_IdleTimer_timeout():
	can_next_line = true
	$E.visible = true


func start_idle_timer():
	can_next_line = false
	$IdleTimer.start()
