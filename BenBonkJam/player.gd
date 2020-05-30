extends KinematicBody2D

var player = true
var direction = Vector2(0,0)
var velocity = Vector2(0,0)
var acc = 0.15
var dcc = 0.2
export var SPEED = 800
onready var head = get_node("body/head")
export var health = 1
var dead = false
var cam

func _ready():
	cam = get_tree().get_nodes_in_group("cam")[0]
	
func damage(d):
	if dead: return
	health -= d
	if health < 0:
		die()
		
func die():
	dead = true
	$Particles2D.emitting = true
	$body.modulate = Color.black
	cam.add_trauma(0.4)

func _physics_process(delta):
	if dead: return
	if direction:
		velocity = lerp(velocity, direction * SPEED, acc)
	else:
		velocity = lerp(velocity, direction * SPEED, dcc)
	move_and_slide(velocity)
	velocity = velocity * pow(0.8,15 * delta)
	if player: head.look_at(get_global_mouse_position())
	elif direction: head.rotation = lerp_angle(head.rotation, direction.angle(), acc)

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
