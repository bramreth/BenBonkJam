extends Node2D

var cam
var people
var wolves = 0
var casualties = 0
export var acceptable_casualties = 3

func _ready():
	randomize()
	cam = get_tree().get_nodes_in_group("cam")[0]
	setup_wave()
	
func setup_wave():
	var spawners = get_tree().get_nodes_in_group("spawner")
	var num_enemies = 2
	var num_allies = 1
	
	for s in get_tree().get_nodes_in_group("spawner"):
		var list = []
		for i in range(num_enemies):
			list.append(0)
		for i in range(num_allies):
			list.append(1)
		list.shuffle()
		s.setup(list)
		s.connect("death", self, "parse_death")
	wolves = num_enemies * len(spawners)
	cam.initg(num_enemies * len(spawners), acceptable_casualties)
	# we need to setup the enemy pattern here

func parse_death(type):
	match type:
		0:
			wolves -= 1
			cam.wolf_death(wolves)
		1:
			casualties += 1
			cam.civilian_casualty(casualties)
		_:
			print("BIG ERROR in parse death")
	if wolves <= 0:
		print("YOU WIN")
		cam.win()
	if casualties >= acceptable_casualties:
		print("YOU LOSE")
		cam.lose()
