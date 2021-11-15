extends Node

var inverted = false
var safe = false
var normal_enemies = ['Skeleton']
var inverted_enemies = ['Ghost']

var player

signal sneak(sneaking)
signal invert(inverted)
