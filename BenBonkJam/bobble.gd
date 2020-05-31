extends Node2D

func _ready():
	var opt = $bubble/AnimationPlayer.get_animation_list()
	$bubble/AnimationPlayer.play(opt[randi()%opt.size()])


func _on_AnimationPlayer_animation_finished(anim_name):
	var opt = $bubble/AnimationPlayer.get_animation_list()
	$bubble/AnimationPlayer.play(opt[randi()%opt.size()])
