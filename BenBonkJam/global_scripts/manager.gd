extends Node

var outfits = null
var enemy_color
var level = 0
var progression = 1

func _ready():
	randomize()
	level = randi() % 3
	
func update_outfits(o):
	if not outfits and o: 
		outfits = o
		enemy_color = outfits[randi() % len(outfits)]

func next_level(won):
	level = randi() % 3
	enemy_color = outfits[randi() % len(outfits)]
	if won:
		progression += 1
