extends Control

var lv = preload("res://level.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	get_tree().change_scene_to(lv)


func _on_Button3_pressed():
	get_tree().quit()


func _on_Button4_pressed():
	# how to play
	$howto_player.play("hide")


func _on_Button_pressed():
	hide()
	$howto_player.play_backwards("hide")

func hide():
	$Node2D/bubble/speech.visible = false

func speak(text):
	if not $Node2D/bubble/speech.visible:
		$Node2D/bubble/speech.visible = true
	$Node2D/bubble/speech/speech.text = text

func _on_who_pressed():
	var txt = "you are a secret agent in a small village occupied by a secret society of villains called the wolves."
	speak(txt)


func _on_what_is_my_mission_pressed():
	var txt = "you are tasked with identifying and eliminating the wolves without harming the locals."
	speak(txt)


func _on_identify_pressed():
	var txt = "you can interrogate someone by approaching and r clicking. your phone will update with details of the most likely wolf disguise."
	speak(txt)


func _on_wolf_pressed():
	var txt = "every day wolves will share a specific disguise like wearing green. also they will attack when your back is turned."
	speak(txt)


func _on_kill_pressed():
	var txt = "we have armed you with a 'killalot' grenade launcher - l click to shoot. at close range it will not explode for precision kills."
	speak(txt)
