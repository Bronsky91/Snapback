extends Node2D

onready var lich_player = $InvertedLich/AnimationPlayer
onready var voice_gen = $UI/DialoguePlayer/VoiceGeneratorAudioStreamPlayer

var track_length = 105
var can_invert = false


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
	$UI/InvertScreen.visible = true
	$BlackTop.visible = false
	$Lich.visible = false
	$InvertedLich.visible = true
	$TileMap.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$SceneAnimator.play("inverted")
	# reverse background music
	var playback_pos = $BGM.get_playback_position()
	var reversed_pos = track_length - playback_pos if track_length - playback_pos >= 0 else 0
	$BGM.stream = load("res://Assets/Audio/boss_reverse.mp3")
	$BGM.play(reversed_pos)


func uninvert():
	$UI/Shockwave/AnimationPlayer.play("normal")
	$UI/Shockwave.visible = true
	$YSort/PlayerOnRails/PlayerAnimator.play("IdleBack")
	$UI/InvertScreen.visible = false
	$BlackTop.visible = false
	$Lich/LichBody.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichShoulder.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichJaw.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichHead.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/LichArms.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich/TileMap.modulate = Color(1.0, 1.0, 1.0, 1.0)
	$Lich.visible = true
	$InvertedLich.visible = false
	$UI/White.visible = false
	$SFX.stream = load("res://Assets/Audio/lich_switch.mp3")
	$SFX.play()
	# $SceneAnimator.play("inverted")
	# reverse background music
	var playback_pos = $BGM.get_playback_position()
	var reversed_pos = track_length - playback_pos if track_length - playback_pos >= 0 else 0
	$BGM.stream = load("res://Assets/Audio/boss.mp3")
	$BGM.play(reversed_pos)


func _lightswitch():
	$SFX.stream = load("res://Assets/Audio/switch.mp3")
	$SFX.play()
	$UI/White.modulate = Color(1.0, 1.0, 1.0, 0.75)


func _on_ShockwavePlayer_animation_finished(anim_name):
	$UI/Shockwave.visible = false
