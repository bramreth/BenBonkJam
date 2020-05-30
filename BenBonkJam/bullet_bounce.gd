extends RigidBody2D

var direction = Vector2()
var speed = 2500
export var d = 33
var explode = false
var explosion_thresh = 200
	
func _ready():
	randomize()
	apply_central_impulse(direction * speed)

func _on_bullet_body_entered(body):
	if explode and linear_velocity.length() > explosion_thresh:	
		explode()
	if body.name == "player" or body.name.begins_with("enemy") or body.name.begins_with("ally"):
		if not body.dead:
			body.damage(d)
			queue_free()

func explode():
	linear_damp = 100
	$AudioStreamPlayer2D.pitch_scale += (randf()-0.5) / 10
	$AudioStreamPlayer2D.play()
	$Light2D/CurveTween.play(1, 0, 2)
	$Timer.set_paused(true)
	$Sprite/CurveTween.play(0.15, 0, $Sprite.scale.x)
	$AnimationPlayer.play("explode")
	print($Area2D.get_overlapping_bodies())
	for item in $Area2D.get_overlapping_bodies():
		if item.name == "player" or item.name.begins_with("enemy") or item.name.begins_with("ally"):
			if not item.dead:
				item.damage(d)
		

func _on_Timer_timeout():
	explode()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_fuse_timeout():
	explode = true


func _on_CurveTween_curve_tween(sat):
	$Light2D.scale = Vector2(sat, sat)
	$Light2D.energy = sat


func size_curve(sat):
	$Sprite.scale = Vector2(sat, sat)
