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
	$body/head/gun/AnimationPlayer.play("reload")
	cam.add_trauma(0.15)
	
func _physics_process(delta):
	if dead: return
	if Input.get_action_strength("click") and can_shoot:
		shoot()
		
func die():
	if dead: return
	dead = true
	$Particles2D.emitting = true
	$body.modulate = Color.black
	cam.add_trauma(1)
	emit_signal("dead", 2)

func _on_CurveTween_curve_tween(sat):
	$body/head/gun.position.x = sat


func _on_AnimationPlayer_animation_finished(anim_name):
	can_shoot = true



func _on_Area2D_body_entered(body):
	if body.name.match("*enemy*"):
		body.test_aggro(self)
