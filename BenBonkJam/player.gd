extends KinematicBody2D

signal dead(type)

var player = true
var direction = Vector2(0,0)
var velocity = Vector2(0,0)
var acc = 0.15
var dcc = 0.2
export var SPEED = 800
onready var head = get_node("body/head")
onready var body = get_node("body")
export var health = 1
var dead = false
var cam
onready var f_check = get_node("body/head/RayCast2D")
export(Array, Color) var outfits
var suspicion = 0
var n = ""
var f = ""


func _ready():
	randomize()
#	var s = ((randf()-0.5)/5)
#	scale += Vector2(s,s)
	n = Names.forename[randi()%len(Names.forename)] + " " + Names.surname[randi()%len(Names.surname)]
	f = Names.facts[randi()%len(Names.facts)]
	Manager.update_outfits(outfits)
	cam = get_tree().get_nodes_in_group("cam")[0]
	
	
func damage(d, origin=Vector2(0,0)):
	$spurt.restart()
	$spurt.look_at(origin)
	cam.add_trauma(0.1)
	if dead: return
	health -= d
	if health < 0:
		die()
		
func die():
	if dead: return
	dead = true
	$Particles2D.emitting = true
	$body.modulate = Color.black
	if player: cam.add_trauma(1)
	else: 
		cam.add_trauma(0.1)
		
		

func _physics_process(delta):
	if dead: return
	if direction:
		velocity = lerp(velocity, direction * SPEED, acc)
	else:
		velocity = lerp(velocity, direction * SPEED, dcc)
	move_and_slide(velocity)
	velocity = velocity * pow(0.8,15 * delta)
	if player: head.look_at(get_global_mouse_position())
	elif direction: 
		head.rotation = lerp_angle(head.rotation, direction.angle(), acc)
		if f_check.get_collider():
			direction = direction.tangent()
			#FIXME this is a bad way to stop collisions
			
	

func _input(InputEvent):
	handle_inputs()
	
func handle_inputs():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()

static func lerp_angle(a, b, t):
	if abs(a-b) >= PI:
		if a > b:
			a = normalize_angle(a) - 2.0 * PI
		else:
			b = normalize_angle(b) - 2.0 * PI
	return lerp(a, b, t)


static func normalize_angle(x):
	return fposmod(x + PI, 2.0*PI) - PI


func _on_line_of_sight_body_exited(body):
	if body.name == "enemy" and player:
		body.out_of_sight(true)

func generate_costume(is_enemy):
	var costumes = outfits.duplicate()
	if Manager.level == 0:
		#enemies wear shades
		if is_enemy: $body/head/shade.visible = true
	else:
		$body/head/shade.visible = randi() % 2 == 0
		
	if Manager.level == 3:
		#enemies wear hat
		if is_enemy: $body/head/Node2D/coffee.visible = true
	else:
		$body/head/Node2D/coffee.visible = randi() % 2 == 0
#	print("MANAGER LV ", Manager.level)
#	match Manager.level:
#		4:
#			if is_enemy: $body/head/Node2D/bouquet.visible = true
#			else:
#				match randi() % 5:
#					1:
#						$body/head/Node2D/briefcase.visible = true
#					2: 
#						$body/head/Node2D/coffee.visible = true
#					_:
#						pass
#		5:
#			if is_enemy: $body/head/Node2D/briefcase.visible = true
#			else:
#					match randi() % 5:
#						0:
#							$body/head/Node2D/bouquet.visible = true
#						2: 
#							$body/head/Node2D/coffee.visible = true
#						_:
#							pass
#		6:
#			if is_enemy: $body/head/Node2D/coffee.visible = true
#			else:
#				match randi() % 5:
#					0:
#						$body/head/Node2D/bouquet.visible = true
#					1:
#						$body/head/Node2D/briefcase.visible = true
#					_:
#						pass
	
	
	if Manager.level == 1:
		#enemies are one color
		if Manager.enemy_color in costumes: costumes.erase(Manager.enemy_color)
#		print(costumes)
	body.self_modulate = costumes[randi() % len(costumes)]
	if Manager.level == 1 and is_enemy: body.self_modulate = Manager.enemy_color
	head.self_modulate = body.self_modulate
	head.self_modulate.r = clamp(head.self_modulate.r * 1.33, 0, 1)
	head.self_modulate.g = clamp(head.self_modulate.g * 1.33, 0, 1)
	head.self_modulate.b = clamp(head.self_modulate.b * 1.33, 0, 1)
	
func interogate():
	if dead: return
	var txt = ""
	match ceil(suspicion):
		1.0:
			txt = "looks innocent"
		2.0:
			txt = "slightly suspicious"
		3.0:
			txt = "suspicious"
		4.0:
			txt = "very suspicious"
		5.0:
			txt = "looks guilty"
		_:
			txt = ""
	$Node2D/Panel/VBoxContainer/suspicion.text = txt
	$Node2D/Panel/VBoxContainer/name.text = n
	$Node2D/Panel/VBoxContainer/fact.text = f
	$Node2D/Panel/interog_player.play("open")
	$Node2D/Timer.start()
	$bod
	return {"c": body.self_modulate, "s": suspicion, "h": $body/head/shade.visible, "cof": $body/head/Node2D/coffee.visible, "uid": self}

func alert(on):
	if dead: return
	if on:
		$body/alert/AnimationPlayer.play("alert")
	else:
		$body/alert/AnimationPlayer.play_backwards("alert")

func _on_Timer_timeout():
	$Node2D/Panel/interog_player.play_backwards("open")
