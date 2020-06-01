extends "res://player.gd"

var seen_player = false
var out_of_sight = false
var aggro = false

func _ready():
	randomize()
	suspicion = randf() * 4
	player = false
	generate_costume(false)

func die():
	if dead: return
	dead = true
	$Particles2D.emitting = true
	$thought.emitting = false
	$attack.emitting = false
	$body.modulate = Color.black
	cam.add_trauma(0.4)
	$id.restart()
	emit_signal("dead", 1)

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
	walk_to_dest()
#
#	if global_position.x < -980:
#		direction.x = 0.3
#	elif global_position.x > 980:
#		direction.x = -0.3
#	if global_position.y < -600:
#		direction.y = 0.3
#	elif global_position.y > 600:
#		direction.y = -0.3

func out_of_sight(b):
	if dead: return
	if b and seen_player and position.distance_to(seen_player.position) < 300:
		aggro = true
		$thought.emitting = false
#		$attack.emitting = true

