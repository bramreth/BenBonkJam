extends Area2D

var direction = Vector2()
var speed = 2000
export var d = 33
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	global_position += direction * speed * delta
	


func _on_bullet_body_entered(body):
	if body.name == "player" or body.name.match("*enemy*"):
		body.damage(d, global_position)
		queue_free()


func _on_Timer_timeout():
	queue_free()
