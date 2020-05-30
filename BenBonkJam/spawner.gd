extends Position2D
export var s = "a"
export var enemies = 1
export var allies = 1
export var delay = 3
var count = 0

signal death(type)

var e = preload("res://enemy.tscn")
var a = preload("res://ally.tscn")
var map = {0: e, 1: a}
export var ls = []

func setup(l_in):
	ls = l_in
	$Timer.start()
#	print(l_in)

func death(type):
	emit_signal("death", type)

func _on_Timer_timeout():
	if ls:
		var t = ls.pop_front()
		var scene = map[t].instance()
		if t: scene.name = "ally" + str(s)+ str(count)
		else: scene.name = "enemy" + str(s)+ str(count)
#		print(scene.name)
		scene.connect("dead", self, "death")
		add_child(scene)
#		load_ai(map[ls.pop_front()])
	
	
