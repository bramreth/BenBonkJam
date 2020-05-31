extends Node2D

var toggle = true
var accuracy = 0.0
var likely_color = {}
var likely_feature = {}
var uid = []
var pop = 0
var targ = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	likely_feature["shades"] = 0
	likely_feature["no_shades"] = 0
	randomize()

func win(on, k, m):
	print(m)
	var tm = 1 + pow(1-m, 2)*2
	tm = stepify(tm,0.01)
	$VBoxContainer2/HBoxContainer/Label2.text = "£" + str(k)
	$VBoxContainer2/HBoxContainer2/Label2.text =  str(tm)
	targ = k*tm
	if on: $bubble/bubble2/w.emitting = true
	else: $bubble/bubble2/l.emitting = true
	
func tween_m():
	var start = 0
	var end = ceil(targ)
	var l = log(targ) /log(10)
	$VBoxContainer2/HBoxContainer3/Label2/c.play(0.2 + l, start, end)
	
	
func up_c(c, ct, on=true):
	$ColorRect/s_count.text = str(c)+"/" + str(ct)
	if on: $bubble/bubble2/bad.restart()
	
func up_w(w, on=true):
	$ColorRect/w_count.text = "x" + str(w)
	if on: $bubble/bubble2/good.restart()

func _on_AnimationPlayer_animation_finished(anim_name):
	var opt = $bubble/AnimationPlayer.get_animation_list()
	$bubble/AnimationPlayer.play(opt[randi()%opt.size()])

func toggle(on):
	toggle = on
	if on:
		$toggle_player.play("open")
	else:
		$toggle_player.play_backwards("open")

func level(i):
	$level.text = "level:" + str(i)

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
	$VBoxContainer/Label.text = "accuracy: " + str(100 * accuracy / pop) + "%" + str(pop)
#	if len(uid) < 3: return
	var tally = 0
	for c in likely_color:
		tally += likely_color[c]
	for c in likely_feature:
		tally += likely_feature[c]
	for c in likely_color:
		if likely_color[c] == likely_color.values().max():
			$VBoxContainer/HBoxContainer/likely.color = c
			$VBoxContainer/HBoxContainer/Label.text = str((float(accuracy) / pop)*100 * likely_color[c] / tally).substr(0,2) + "%"
	$VBoxContainer/HBoxContainer5/label.text = str((float(accuracy) / pop)*(100 * likely_feature["shades"]) / (likely_feature["shades"] + likely_feature["no_shades"])).substr(0,2) + "%"
	$VBoxContainer/Label.text = "accuracy: " + str(100 * accuracy / pop) + "%"
	
	
func add_cash():
	$toggle_player.play("win")

func _on_c_curve_tween(sat):
	$VBoxContainer2/HBoxContainer3/Label2.text =  "£" + str(ceil(sat))
