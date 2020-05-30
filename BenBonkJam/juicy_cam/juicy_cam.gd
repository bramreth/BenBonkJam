extends Camera2D

var menu = false
var ac = 0
export (OpenSimplexNoise) var noise
export(float, 0, 1) var trauma = 0.0

export var max_x = 150
export var max_y = 150
export var max_r = 25

export var time_scale = 150

export(float, 0, 1) var decay = 0.6

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	if not menu: return
	if Input.get_action_strength("ui_accept"): get_tree().reload_current_scene()
		
func lose():
	$CanvasLayer/blur/CenterContainer/result.text = "too many civilian casualties."
	menu = false
	blur()
	
func win():
	$CanvasLayer/blur/CenterContainer/result.text = "you eliminated the wolves.\n well done agent."
	menu = false
	blur()
	
func die():
	$CanvasLayer/blur/CenterContainer/result.text = "The wolves got them.\n that's a pity."
	menu = false
	blur()
	
func blur():
	$CanvasLayer/blur/CurveTween.play(1.0, float(menu), float(not menu))
	menu = not menu
	

func _on_CurveTween_curve_tween(sat):
	$CanvasLayer/blur.get_material().set_shader_param("str", sat)
	$CanvasLayer/blur/CenterContainer/result.modulate.a = sat

func initg(total_w, total_c):
	$CanvasLayer/Control/CenterContainer/VBoxContainer/wolves_remaing.text = "wolves remaing: " + str(total_w)
	$CanvasLayer/Control/CenterContainer/VBoxContainer/civilian_casualties.text = "civilian casualties: " + str(0) + " / " + str(total_c)
	ac = total_c
	
func civilian_casualty(c):
	$CanvasLayer/Control/CenterContainer/VBoxContainer/civilian_casualties.text = "civilian casualties: " + str(c) + " / " + str(ac)
	
func wolf_death(w):
	$CanvasLayer/Control/CenterContainer/VBoxContainer/wolves_remaing.text = "wolves remaing: " + str(w)

	
