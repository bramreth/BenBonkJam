extends "res://player.gd"

var bullet = preload("res://bullet_bounce.tscn")
var can_shoot = true

func _ready():
	SPEED = SPEED + ((Manager.speed - 1) * 125)
	health = health + (Manager.health*2) - 2
#	print("HEALTH", health)
	$body/head/Node2D/briefcase.visible = Manager.b_equip
	$body/head/Node2D/bouquet.visible = Manager.f_equip
	$body/head/Node2D/coffee.visible = Manager.c_equip
	$body/head/hat/crown.visible = Manager.crown
		
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
		
func _input(event):
	if Input.get_action_strength("rclick"):
		var q = false
		for item in $body/head/interrog.get_overlapping_bodies():
			if not item == self:
				if item.has_method("interogate"):
					var res = item.interogate()
#					print(res)
					if res:
						cam.gather_data(res)
			else:
				q = true
		if q and not $body/head/q.emitting: 
			$body/head/q.restart()
			$body/head/interrog/AudioStreamPlayer2D/AnimationPlayer.play("trill")
		
func die():
	if dead: return
	dead = true
	$Particles2D.emitting = true
	$body.modulate = Color.black
	cam.add_trauma(1)
	emit_signal("dead", 2)

func _on_CurveTween_curve_tween(sat):
	$body/head/gun.position.x = sat

func rand_pitch():
	$body/head/interrog/AudioStreamPlayer2D.pitch_scale = 1 + randf()

func _on_AnimationPlayer_animation_finished(anim_name):
	can_shoot = true



func _on_Area2D_body_entered(body):
	if body.name.match("*enemy*"):
		body.test_aggro(self)


func _on_interrog_body_entered(body):
	if body.name.match("*enemy*") or body.name.match("*ally*"):
		body.alert(true)


func _on_interrog_body_exited(body):
	if body.name.match("*enemy*") or body.name.match("*ally*"):
		body.alert(false)
