extends Node2D


var toggle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_AnimationPlayer_animation_finished(anim_name):
	var opt = $bubble/AnimationPlayer.get_animation_list()
	$bubble/AnimationPlayer.play(opt[randi()%opt.size()])

func toggle(on):
	toggle = on
	if on:
		$toggle_player.play("open")
	else:
		$toggle_player.play_backwards("open")


func _on_toggle_player_animation_finished(anim_name):
	if toggle:
		var opt = $bubble/AnimationPlayer.get_animation_list()
		$bubble/AnimationPlayer.play(opt[randi()%opt.size()])
