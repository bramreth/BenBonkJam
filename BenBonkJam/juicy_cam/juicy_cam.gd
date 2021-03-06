extends Camera2D

var menu = false
var ac = 0
export (OpenSimplexNoise) var noise
export(float, 0, 1) var trauma = 0.0



export var max_x = 150
export var max_y = 150
export var max_r = 25

export var time_scale = 150
var proc = false
export(float, 0, 1) var decay = 0.6
var won = false
var time = 0
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/HBoxContainer/OptionButton.select(Manager.song)
	update_song()
	player = get_tree().get_nodes_in_group("player")[0]
	$CanvasLayer/eol.get_material().set_shader_param("intensity", 1)
	$CanvasLayer/phone.level(Manager.progression)
	$CanvasLayer/TextureRect2/day.text = "day: " + str(Manager.progression)
	$AudioStreamPlayer.volume_db = linear2db(Manager.sound_vol/2)
	update_mute()
	
	start_day()
	
func update_settings():
	$AudioStreamPlayer.volume_db = linear2db(Manager.sound_vol/2)

func start_day():
	$CanvasLayer/eol/AnimationPlayer.play("open")
	

func add_trauma(trauma_in):
	trauma = clamp(trauma + trauma_in, 0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	var shake = pow(trauma, 2)
	offset.x = noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
	offset.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	if trauma > 0: trauma = clamp(trauma - (delta * decay), 0, 1)

		
func lose(k, m):
	$CanvasLayer/TextureRect/speak.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "too many civilian casualties. \n unnaceptable."
	menu = false
	$CanvasLayer/phone.win(false, k, m)
	player.dead = true
	blur()
	
func win(k, m):
	$CanvasLayer/TextureRect/speak.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "you eliminated the wolves.\n well done agent."
	menu = false
	won = true
	player.dead = true
	$CanvasLayer/phone.win(true, k, m)
	blur()
	
func die(k, m):
	$CanvasLayer/TextureRect/speak.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "That's a pity, Send in the next agent!"
	$CanvasLayer/phone.win(false, k, m)
	menu = false
	player.dead = true
	blur()
	
func blur():
	$CanvasLayer/blur/CurveTween.play(1.0, float(menu), float(not menu))
	menu = not menu
	

func _on_CurveTween_curve_tween(sat):
	$CanvasLayer/blur.get_material().set_shader_param("str", sat)
#	$CanvasLayer/TextureRect/CenterContainer/result.modulate.a = sat

func initg(total_w, total_c, p):
	$CanvasLayer/phone.up_c(0, total_c, false)
	$CanvasLayer/phone.up_w(total_w, false)
	ac = total_c
	$CanvasLayer/phone.pop = p
	
	
func civilian_casualty(c):
	$CanvasLayer/phone.up_c(c, ac)
	
func wolf_death(w):
	$CanvasLayer/phone.up_w(w)

	
func gather_data(res):
	$CanvasLayer/phone.txt(res)


func _on_phone_menu():
	var menu_scene = load("res://menu.tscn")
	get_tree().change_scene_to(menu_scene)


func _on_phone_next():
	$CanvasLayer/eol/AnimationPlayer.play("close")
	$AudioStreamPlayer/atween.play(0.5, Manager.sound_vol, 1)
	


func _on_phone_shop():
	$CanvasLayer/WindowDialog.popup()
	$CanvasLayer/phone.visible = false


func _on_WindowDialog_close():
	$CanvasLayer/phone.visible = true

func _input(event):
	if Input.get_action_strength("ui_home"):
		win(1, 1)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "close":
		if Manager.progression == 8:
			get_tree().change_scene("res://win.tscn")
		else:
			get_tree().reload_current_scene()
	else:
		$CanvasLayer/phone.toggle(true)
		set_tip()
		$CanvasLayer/TextureRect/speak.play("speak_quick")
		$CanvasLayer/TextureRect2/AnimationPlayer.play("drop")

func set_tip():
#	print("tip")
	var txt = ""
	match Manager.level:
		2:
			txt = "They're all wolves! defend yourself!"
		1:
			txt = "intelligence reports the wolves all share a colour."
		_:
			txt = "intelligence reports the wolves are all wearing or holding a specific item."
	$CanvasLayer/TextureRect/CenterContainer/result.text = txt
#	print($CanvasLayer/TextureRect/CenterContainer/result.text)
#	match Manager.level


func _on_atween_curve_tween(sat):
#	print(linear2db(sat))
	$AudioStreamPlayer.volume_db -=1


func _on_speak_animation_finished(anim_name):
	if anim_name == "speak":
		Manager.next_level(won)
		$CanvasLayer/phone.add_cash()

var m1 = preload("res://assets/vol (1).png")
var m2 = preload("res://assets/vol (2).png")

func update_mute():
	if Manager.mute:
		$CanvasLayer/HBoxContainer/TextureButton.set_normal_texture(m2)
	else:
		$CanvasLayer/HBoxContainer/TextureButton.set_normal_texture(m1)

func _on_TextureButton_pressed():
	#toggle mute
	Manager.mute(not Manager.mute)
	update_mute()
	
func update_song():
	match int(Manager.song):
		0:
			$AudioStreamPlayer.stream = load("res://audio/urgent.wav")
		1:
			$AudioStreamPlayer.stream = load("res://audio/songs/ass(1).wav")
	$AudioStreamPlayer.play()

func _on_OptionButton_item_selected(id):
	Manager.song = id
	update_song()
