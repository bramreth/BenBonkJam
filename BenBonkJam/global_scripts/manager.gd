extends Node

var outfits = null
var enemy_color
var level = 0
var progression = 10

var difficulty = 1
var acceptable = 3
var cash = 0
var best_level = 0
var best_difficulty = 1000

var speed = 1

func _ready():
	load_game()
	randomize()
	level = randi() % 4
	
func update_outfits(o):
	if not outfits and o: 
		outfits = o
		enemy_color = outfits[randi() % len(outfits)]

func next_level(won):
	if (level == best_level and difficulty < best_difficulty) or level > best_level:
		best_level = level
		best_difficulty = difficulty
	save()
	level = randi() % 4
	enemy_color = outfits[randi() % len(outfits)]
	if won:
		progression += 1

func save():
	var save_dict = {"level": best_level, "diff": difficulty, "cash": cash, "speed": speed}
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if current_line is Dictionary:
			if current_line.has("level"):
				best_level = current_line["level"]
			if current_line.has("diff"):
				best_difficulty = current_line["diff"]
			if current_line.has("cash"):
				cash = current_line["cash"]
			if current_line.has("speed"):
				speed = current_line["speed"]
				print(current_line["speed"])
	save_game.close()
