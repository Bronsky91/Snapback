extends Node2D

onready var lich_player = $Lich/AnimationPlayer
onready var inverted_lich_player = $InvertedLich/AnimationPlayer
onready var voice_gen = $UI/DialoguePlayer/VoiceGeneratorAudioStreamPlayer

var track_length = 105
var can_invert = false
var is_talking = false


func _ready():
	print("final_score")
	print(g.final_score)
	VisualServer.set_default_clear_color(Color(0.0,0.0,0.0,1.0))
	$YSort/PlayerOnRails/Camera2D.position = Vector2(0, 500)
	$InvertedLich/LichEyes/RightEyeGlow.visible = false
	$InvertedLich/LichEyes/LeftEyeGlow.visible = false
	$BGM.stream = load("res://Assets/Audio/boss.mp3")
	$BGM.play()
	$SceneAnimator.play("start")


func _process(delta):
	var should_be_talking = voice_gen.is_reading() and not voice_gen.is_waiting()
	
	# regular lich
	var anim = lich_player.current_animation
	if should_be_talking and anim != "Talking":
		lich_player.play("Talking")
	elif not should_be_talking and anim != "Idle":
		lich_player.play("Idle")
	
	# inverted lich
	var inverted_anim = inverted_lich_player.current_animation
	if should_be_talking and inverted_anim != "Talking":
		inverted_lich_player.play("Talking")
	elif not should_be_talking and inverted_anim != "Idle":
		inverted_lich_player.play("Idle")


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
	$UI/InvertScreen.visible = true
	$BlackTop.visible = false
	$Lich.visible = false
	$InvertedLich.visible = true
	$TileMap.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$SceneAnimator.play("inverted")
	$SFX.stream = load("res://Assets/Audio/flip_reverse.mp3")
	$SFX.play()
	# reverse background music
	var playback_pos = $BGM.get_playback_position()
	var reversed_pos = track_length - playback_pos if track_length - playback_pos >= 0 else 0
	$BGM.stream = load("res://Assets/Audio/boss_reverse.mp3")
	$BGM.play(reversed_pos)


func uninvert():
	$YSort/PlayerOnRails/PlayerAnimator.play("IdleBack")
	$UI/InvertScreen.visible = false
	$Lich/LichBody.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichShoulder.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichJaw.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichHead.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichArms.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/TileMap.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich.visible = true
	$InvertedLich.visible = false
	$UI/White.visible = false
	# reverse background music
	var playback_pos = $BGM.get_playback_position()
	var reversed_pos = track_length - playback_pos if track_length - playback_pos >= 0 else 0
	$BGM.stream = load("res://Assets/Audio/boss.mp3")
	$BGM.play(reversed_pos)
	# begin judgement dialogue
	$UI/DialoguePlayer.judgement()


func _lightswitch():
	$SFX.stream = load("res://Assets/Audio/lich_switch.mp3")
	$SFX.play()
	$UI/White.modulate = Color(1.0, 1.0, 1.0, 0.75)
	$UI/Shockwave/AnimationPlayer.play("normal")
	$UI/Shockwave.visible = true


func pizza():
	$PizzaTimer.start()


func high_score():
	$SceneAnimator.play("high_score")


func _on_ShockwavePlayer_animation_finished(anim_name):
	$UI/Shockwave.visible = false


func _on_PlayerAnimator_animation_finished(anim_name):
	if anim_name == "Pizza":
		$YSort/PlayerOnRails/PlayerAnimator.play("PizzalessIdle")


func _on_PizzaTimer_timeout():
	$YSort/PlayerOnRails/PlayerAnimator.play("Pizza")
