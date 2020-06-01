extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Manager.cash += 30
	Manager.save()
	$Sprite/bubble/AnimationPlayer.play("bobble_1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	var opt = $Sprite/bubble/AnimationPlayer.get_animation_list()
	$Sprite/bubble/AnimationPlayer.play(opt[randi()%opt.size()])


func _on_Button_pressed():
	get_tree().change_scene("res://level.tscn")
