extends "res://player.gd"

var bullet = preload("res://bullet.tscn")
var can_shoot = true
var cam = get_tree().get_nodes_in_group("cam")[0]


		
func shoot():
	can_shoot = false
	var b = bullet.instance()
	b.direction = Vector2(cos(head.rotation), sin(head.rotation))
	b.global_position = $body/head/gun/origin.global_position
	get_tree().get_root().add_child(b)
	$body/head/gun/origin/flash.restart()
	
	$body/head/gun/Timer.start()
	cam.add_trauma(0.5)
	
func _physics_process(delta):
	if dead: return
	if Input.get_action_strength("click") and can_shoot:
		shoot()

func _on_Timer_timeout():
	can_shoot = true
