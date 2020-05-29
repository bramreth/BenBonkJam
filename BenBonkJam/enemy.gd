extends "res://player.gd"

var seen_player = false
var out_of_sight = false
var aggro = false

func _ready():
	player = false

func _process(delta):
	if dead: return
	var spot1 = $body/head/RayCast2D.get_collider()
	var spot2 = $body/head/RayCast2D2.get_collider()
	if spot1:
		if spot1.name == "player":
			seen_player = spot1
			$thought.emitting = true
	if spot2:
		if spot2.name == "player":
			seen_player = spot2
			$thought.emitting = true
	handle_inputs()

func handle_inputs():
	if position.x < 100:
		direction.x = 0.3
	elif position.x > 800:
		direction.x = -0.3
	if aggro:
		var angle = get_angle_to(seen_player.position)
		direction = Vector2(cos(angle), sin(angle))

func out_of_sight(b):
	if b and seen_player and position.distance_to(seen_player.position) < 300:
		aggro = true
		$thought.emitting = false
		$attack.emitting = true

