extends Node2D

var cam
var people
var wolves = 0
var max_w = 0
var casualties = 0
export var acceptable_casualties = 3

func _ready():
	randomize()
	cam = get_tree().get_nodes_in_group("cam")[0]
	setup_wave()
	
func setup_wave():
	var num_enemies = 0
	var num_allies = 0
	var spawners = get_tree().get_nodes_in_group("spawner")
	if Manager.level == 2:
		num_enemies = (Manager.progression * 2) + randi() %  Manager.progression
	else:
		num_enemies = Manager.progression + randi() %  Manager.progression
		num_allies = Manager.progression + randi() %  Manager.progression
		
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
	max_w = wolves
	print(num_enemies + num_allies)
	Manager.acceptable = min(num_allies* len(spawners), Manager.difficulty)
	cam.initg(num_enemies * len(spawners), Manager.acceptable, (num_enemies + num_allies)*get_tree().get_nodes_in_group("spawner").size())
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
		if Manager.acceptable:
			cam.win(max_w - wolves, float(casualties) / Manager.acceptable)
		else:
			cam.win(max_w - wolves, 1)
	if casualties >= Manager.acceptable and Manager.acceptable:
		print("YOU LOSE")
		if Manager.acceptable:
			cam.lose(max_w - wolves, float(casualties) / Manager.acceptable)
		else:
			cam.lose(max_w - wolves, 1)


func _on_player_dead(type):
	if Manager.acceptable:
		cam.die(max_w - wolves, float(casualties) / Manager.acceptable)
	else:
		cam.die(max_w - wolves, 1)
