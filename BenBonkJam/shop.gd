extends WindowDialog
signal up_manager()
signal close()
var speed_price = pow(5, Manager.speed)
var health_price = pow(7, Manager.health)

func _ready():
	if not Manager.crown:
		$VBoxContainer/songs/cof/TextureRect.self_modulate = Color("3d3d3d")
	sanity()
	
func sanity():
	emit_signal("up_manager")
	$Panel/VBoxContainer/cash.text = "£" + str(Manager.cash)
	speed_price = pow(5, Manager.speed)
	health_price = pow(7, Manager.health)
	$VBoxContainer/HBoxContainer/speed/upg.disabled = (Manager.speed > 3) or Manager.cash < speed_price
	if (Manager.health > 3):
		$VBoxContainer/HBoxContainer/health/Label.text = "health max"
		$VBoxContainer/HBoxContainer/speed/cost.text = ""
	else:
		$VBoxContainer/HBoxContainer/health/Label.text = "health " + str(Manager.health)
		$VBoxContainer/HBoxContainer/health/cost.text = "cost: £" + str(health_price)
		
	$VBoxContainer/HBoxContainer/health/hupg.disabled = (Manager.health > 3) or Manager.cash < health_price
	
	if (Manager.speed > 3):
		$VBoxContainer/HBoxContainer/speed/Label.text = "speed max"
		$VBoxContainer/HBoxContainer/speed/cost.text = ""
	else:
		$VBoxContainer/HBoxContainer/speed/Label.text = "speed " + str(Manager.speed)
		$VBoxContainer/HBoxContainer/speed/cost.text = "cost: £" + str(speed_price)
		
	$VBoxContainer/cosmetics/cof/HBoxContainer/cb.disabled =  Manager.c_unlock or Manager.cash < 25
	$VBoxContainer/cosmetics/flowers/HBoxContainer/fb.disabled =  Manager.f_unlock or Manager.cash < 100
	$VBoxContainer/cosmetics/brief/HBoxContainer/bb.disabled =  Manager.b_unlock or Manager.cash < 200
	
	$VBoxContainer/cosmetics/cof/HBoxContainer/cc.disabled =  not Manager.c_unlock
	$VBoxContainer/cosmetics/flowers/HBoxContainer/fc.disabled = not Manager.f_unlock
	$VBoxContainer/cosmetics/brief/HBoxContainer/bc.disabled = not Manager.b_unlock
	
	if Manager.c_equip and not $VBoxContainer/cosmetics/cof/HBoxContainer/cc.pressed:
		$VBoxContainer/cosmetics/cof/HBoxContainer/cc.pressed = true
	if Manager.b_equip and not $VBoxContainer/cosmetics/brief/HBoxContainer/bc.pressed:
		$VBoxContainer/cosmetics/brief/HBoxContainer/bc.pressed = true
	if Manager.f_equip and not $VBoxContainer/cosmetics/flowers/HBoxContainer/fc.pressed:
		$VBoxContainer/cosmetics/flowers/HBoxContainer/fc.pressed = true

func _on_back_pressed():
	emit_signal("close")
	hide()
	sanity()


func _on_upg_pressed():
	Manager.cash -= speed_price
	$AudioStreamPlayer.play()
	Manager.speed = Manager.speed + 1
	Manager.save()
	sanity()


func _on_WindowDialog_about_to_show():
	sanity()


func _on_cb_pressed():
	Manager.cash -= 25
	$AudioStreamPlayer.play()
	Manager.c_unlock = true
	Manager.save()
	# unlock coffee
	sanity()


func _on_fb_pressed():
	Manager.cash -= 100
	$AudioStreamPlayer.play()
	Manager.f_unlock = true
	Manager.save()
	# unlock flower
	sanity()


func _on_bb_pressed():
	Manager.cash -= 200
	$AudioStreamPlayer.play()
	Manager.b_unlock = true
	Manager.save()
	# unlock briefcase
	sanity()

func up_cos():
	Manager.b_equip = $VBoxContainer/cosmetics/brief/HBoxContainer/bc.pressed
	Manager.f_equip = $VBoxContainer/cosmetics/flowers/HBoxContainer/fc.pressed
	Manager.c_equip = $VBoxContainer/cosmetics/cof/HBoxContainer/cc.pressed
	Manager.save()

func _on_cc_toggled(button_pressed):
	up_cos()


func _on_fc_toggled(button_pressed):
	up_cos()


func _on_bc_toggled(button_pressed):
	up_cos()


func _on_buy_pressed():
	pass # Replace with function body.


func _on_hupg_pressed():
	Manager.cash -= health_price
	$AudioStreamPlayer.play()
	Manager.health = Manager.health + 1
	Manager.save()
	sanity()
