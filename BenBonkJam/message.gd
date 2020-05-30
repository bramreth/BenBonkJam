extends Node2D


var toggle = false
var accuracy = 0.0
var likely_color = {}
var likely_feature = {}
var uid = []
var pop = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	likely_feature["shades"] = 0
	likely_feature["no_shades"] = 0
	randomize()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	var opt = $bubble/AnimationPlayer.get_animation_list()
	$bubble/AnimationPlayer.play(opt[randi()%opt.size()])

func toggle(on):
	toggle = on
	if on:
		$toggle_player.play("open")
	else:
		$toggle_player.play_backwards("open")


func _on_toggle_player_animation_finished(anim_name):
	if toggle:
		var opt = $bubble/AnimationPlayer.get_animation_list()
		$bubble/AnimationPlayer.play(opt[randi()%opt.size()])

func txt(t):
	if t["uid"] in uid: return
	uid.append( t["uid"])
	accuracy = len(uid)
	for c in Manager.outfits:
		if not likely_color.has(c):
			likely_color[c] = 0
	print(likely_color)
	likely_color[t["c"]] += pow(t["s"], 2)
	if t["h"]:
		likely_feature["shades"] += pow(t["s"], 2)
	else:
		likely_feature["no_shades"] += pow(t["s"], 2)
	$Label.text = str(100 * accuracy / pop) + "%" + str(pop)
	if len(uid) < 3: return
	var tally = 0
	for c in likely_color:
		tally += likely_color[c]
	for c in likely_feature:
		tally += likely_feature[c]
	for c in likely_color:
		if likely_color[c] == likely_color.values().max():
			$VBoxContainer/HBoxContainer/likely.color = c
			$VBoxContainer/HBoxContainer/Label.text = str(100 * likely_color[c] / tally)
	$VBoxContainer/HBoxContainer5/label.text = str((100 * likely_feature["shades"]) / (likely_feature["shades"] + likely_feature["no_shades"]))
	$Label.text = str(100 * accuracy / pop) + "%" + str(pop)
