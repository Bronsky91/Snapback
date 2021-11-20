extends Node2D

onready var lich_player = $InvertedLich/AnimationPlayer
onready var voice_gen = $UI/DialoguePlayer/VoiceGeneratorAudioStreamPlayer

var can_invert = false

func _ready():
	print("final_score")
	print(g.final_score)
	$YSort/PlayerOnRails/Camera2D.position = Vector2(0, 500)
	$InvertedLich/LichEyes/RightEyeGlow.visible = false
	$InvertedLich/LichEyes/LeftEyeGlow.visible = false
	$SceneAnimator.play("start")


func _process(delta):
	lich_player.play("Talking" if voice_gen.is_reading() and not voice_gen.is_waiting() else "Idle")


func _grumble():
	$SFX.stream = load("res://Assets/Audio/lich_stomach_growl.mp3")
	$SFX.play()
	g.emit_signal('shake', 3, 18, 18, 0)


func _space():
	$UI/Space.visible = true
	can_invert = true


func _input(event):
	if event.is_action_pressed("invert") and can_invert:
		can_invert = false
		invert()


func invert():
	$UI/Space.visible = false
	$UI/Shockwave/AnimationPlayer.play("invert")
	$UI/Shockwave.visible = true
	$YSort/PlayerOnRails/PlayerAnimator.play("InverseIdleBack")
	$UI/InvertScreen.show()
	$BlackTop.visible = false
	$Lich.visible = false
	$InvertedLich.visible = true
	$TileMap.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$SceneAnimator.play("inverted")
