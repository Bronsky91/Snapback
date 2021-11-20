extends Node

var inverted = false
var normal_enemies = ['Skeleton', 'GrimReaper']
var inverted_enemies = ['SkullGhost', 'CuteGhost', 'GrimReaper']
var player
var final_score = {
	"time": 0,
	"coins": 0,
	"slices_lost": 0,
	"skellies_talked_to": 0,
}

signal sneak(sneaking)
signal invert(inverted)
signal go_home(attacker)
signal shake(duration, frequency, amplitude, priority)

const inverse_frame_dict = {
	'InverseIdleFront': 1,
	'InverseIdleLeft': 0,
	'InverseIdleRight': 2,
	'InverseIdleBack': 3,
	'InverseSneakIdleFront': 21,
	'InverseSneakIdleLeft': 13,
	'InverseSneakIdleRight': 29,
	'InverseSneakIdleBack': 37
}
