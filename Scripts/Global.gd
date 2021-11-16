extends Node

var inverted = false
var normal_enemies = ['Skeleton']
var inverted_enemies = ['Ghost']

var player

signal sneak(sneaking)
signal invert(inverted)
signal go_home()
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
