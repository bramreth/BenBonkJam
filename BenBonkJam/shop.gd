extends WindowDialog
signal up_manager()
signal close()
var speed_price = pow(5, Manager.speed)

func _ready():
	sanity()
	
func sanity():
	emit_signal("up_manager")
	$Panel/VBoxContainer/cash.text = "£" + str(Manager.cash)
	speed_price = pow(5, Manager.speed)
	$VBoxContainer/HBoxContainer/speed/upg.disabled = (Manager.speed > 3) or Manager.cash < speed_price
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
	Manager.speed = Manager.speed + 1
	Manager.save()
	sanity()


func _on_WindowDialog_about_to_show():
	sanity()


func _on_cb_pressed():
	Manager.cash -= 25
	Manager.c_unlock = true
	Manager.save()
	# unlock coffee
	sanity()


func _on_fb_pressed():
	Manager.cash -= 100
	Manager.f_unlock = true
	Manager.save()
	# unlock flower
	sanity()


func _on_bb_pressed():
	Manager.cash -= 200
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
