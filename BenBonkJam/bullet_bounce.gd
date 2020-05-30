extends RigidBody2D

var direction = Vector2()
var speed = 2500
export var d = 33
var explode = false
var explosion_thresh = 200
	
func _ready():
	apply_central_impulse(direction * speed)

func _on_bullet_body_entered(body):
	if explode and linear_velocity.length() > explosion_thresh:	
		explode()
	if body.name == "player" or body.name.begins_with("enemy"):
		if not body.dead:
			body.damage(d)
			queue_free()

func explode():
	$AnimationPlayer.play("explode")
	print($Area2D.get_overlapping_bodies())
	for item in $Area2D.get_overlapping_bodies():
		if item.name == "player" or item.name.begins_with("enemy"):
			if not item.dead:
				item.damage(d)
		

func _on_Timer_timeout():
	explode()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()


func _on_fuse_timeout():
	explode = true
