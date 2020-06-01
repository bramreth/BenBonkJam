extends Node

var outfits = null
var enemy_color
var level = 0
var progression = 1

var difficulty = 1
var acceptable = 3
var cash = 0
var best_level = 0
var best_difficulty = 1000

var song = 0

var c_unlock = false
var c_equip = false

var f_unlock = false
var f_equip = false

var crown = false

var b_unlock = false
var b_equip = false

var sound_vol = 0.5

var mute = false
var speed = 1
var health = 1

func _ready():
	load_game()
	randomize()
	level = randi() % 4
	mute(mute)
	
func mute(on):
	mute = on
	AudioServer.set_bus_mute(0, mute)
	
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
	var save_dict = {"level": best_level, "diff": difficulty, "cash": cash, "speed": speed,
	 "bu": b_unlock, "be": b_equip, "cu": c_unlock, "ce": c_equip, "fu": f_unlock, "fe": f_equip ,
	 "vol": sound_vol, "mute": mute, "crown": crown, "song": song, "health": health}
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
			if current_line.has("health"):
				health = current_line["health"]
				print(current_line["health"])
			#"cu": c_unlock, "ce": c_equip, "fu": f_unlock, "fe": f_equip
			if current_line.has("bu"):
				b_unlock = current_line["bu"]
			if current_line.has("be"):
				b_equip = current_line["be"]
			if current_line.has("cu"):
				c_unlock = current_line["cu"]
			if current_line.has("ce"):
				c_equip = current_line["ce"]
			if current_line.has("fu"):
				f_unlock = current_line["fu"]
			if current_line.has("fe"):
				f_equip = current_line["fe"]
			if current_line.has("vol"):
				sound_vol = current_line["vol"]
			if current_line.has("mute"):
				mute = current_line["mute"]
			if current_line.has("crown"):
				crown = current_line["crown"]
			if current_line.has("song"):
				song = current_line["song"]
	save_game.close()
