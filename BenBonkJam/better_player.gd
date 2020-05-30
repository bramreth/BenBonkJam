extends "res://player.gd"

var bullet = preload("res://bullet_bounce.tscn")
var can_shoot = true

		
func shoot():
	can_shoot = false
	var b = bullet.instance()
	b.direction = Vector2(cos(head.rotation), sin(head.rotation))
	b.global_position = $body/head/gun/origin.global_position
	get_tree().get_root().add_child(b)
	$body/head/gun/origin/flash.restart()
	
	$body/head/gun/Timer.start()
	cam.add_trauma(0.15)
	
func _physics_process(delta):
	if dead: return
	if Input.get_action_strength("click") and can_shoot:
		shoot()
		$body/head/gun/CurveTween.play(0.2, $body/head/gun.offset.x, $body/head/gun.offset.x - 25)

func _on_Timer_timeout():
	can_shoot = true


func _on_CurveTween_curve_tween(sat):
	$body/head/gun.offset.x = sat
