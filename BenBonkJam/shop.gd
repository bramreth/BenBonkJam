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
	else:
		$VBoxContainer/HBoxContainer/speed/Label.text = "speed " + str(Manager.speed)
		$VBoxContainer/HBoxContainer/speed/cost.text = "cost: £" + str(speed_price)


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
