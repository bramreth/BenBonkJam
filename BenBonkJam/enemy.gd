extends "res://player.gd"

var seen_player = false
var out_of_sight = false
var aggro = false
onready var atk_area = get_node("body/head/attack_area")
func _ready():
	randomize()
	match int(Manager.difficulty):
		1000:
			suspicion = 4 + randf() * 1
		3:
			suspicion = 3 + randf() * 2
		1: 
			suspicion = 2 + randf() * 3
	player = false
	generate_costume(true)
	if Manager.level == 2: 
		aggro = true
		seen_player = get_tree().get_nodes_in_group("player")[0]

func die():
	if dead: return
	dead = true
	aggro = false
	$body/head/knife/AnimationPlayer.stop()
	$Particles2D.emitting = true
	$thought.emitting = false
	$attack.emitting = false
	$body.modulate = Color.black
	cam.add_trauma(0.4)
	$id.restart()
	emit_signal("dead", 0)

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
	if dead: return
	if global_position.x < -980:
		direction.x = 0.3
	elif global_position.x > 980:
		direction.x = -0.3
	if global_position.y < -600:
		direction.y = 0.3
	elif global_position.y > 600:
		direction.y = -0.3
	if aggro:
		if not $body/head/knife/AnimationPlayer.is_playing():
			$body/head/knife/AnimationPlayer.play("slash")
		var angle = get_angle_to(seen_player.position)
		direction = Vector2(cos(angle), sin(angle))

func out_of_sight(b):
	if dead: return
	if b and seen_player: # and position.distance_to(seen_player.position) < 300:
		aggro = true
		$thought.emitting = false
		$attack.emitting = true

func test_aggro(player):
	if dead: return
	seen_player = player
	aggro = true
	$attack.emitting = true
	
func attack():
	if dead: return
	if atk_area.overlaps_body(seen_player):
		seen_player.damage(1, global_position)
