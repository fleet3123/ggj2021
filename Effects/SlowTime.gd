extends Node

const END_VALUE = 1

onready var timer = $Duration

func start(duration = 0.4, strength = 0.9):
	timer.wait_time = duration
	timer.start()
	Engine.time_scale = strength

func _on_Timer_timeout():
	Engine.time_scale = END_VALUE
