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
# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/phone.level(Manager.progression)
	$CanvasLayer/phone.toggle(true)

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

func _input(event):
#	if Input.get_action_strength("tab"):
#		$CanvasLayer/phone.toggle(not $CanvasLayer/phone.toggle)
	if not menu: return
	if Input.get_action_strength("ui_accept"): 
		if proc: 
			return
		proc = true
		Manager.next_level(won)
		$CanvasLayer/phone.add_cash()
#		get_tree().reload_current_scene()
		
func lose(k, m):
	$CanvasLayer/TextureRect/AnimationPlayer.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "too many civilian casualties. \n unnaceptable.\n press space to continue"
	menu = false
	$CanvasLayer/phone.win(false, k, m)
	blur()
	
func win(k, m):
	$CanvasLayer/TextureRect/AnimationPlayer.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "you eliminated the wolves.\n well done agent.\n press space to continue"
	menu = false
	won = true
	$CanvasLayer/phone.win(true, k, m)
	blur()
	
func die(k, m):
	$CanvasLayer/TextureRect/AnimationPlayer.play("speak")
	$CanvasLayer/TextureRect/CenterContainer/result.text = "The wolves got them - that's a pity. \nSend in the next agent!\n press space to continue"
	$CanvasLayer/phone.win(false, k, m)
	menu = false
	blur()
	
func blur():
	$CanvasLayer/blur/CurveTween.play(1.0, float(menu), float(not menu))
	menu = not menu
	

func _on_CurveTween_curve_tween(sat):
	$CanvasLayer/blur.get_material().set_shader_param("str", sat)
	$CanvasLayer/TextureRect/CenterContainer/result.modulate.a = sat

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
	get_tree().reload_current_scene()


func _on_phone_shop():
	$CanvasLayer/WindowDialog.popup()
	$CanvasLayer/phone.visible = false


func _on_WindowDialog_close():
	$CanvasLayer/phone.visible = true
