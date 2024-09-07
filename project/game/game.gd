extends Control

var current_state

enum state {
	DUNES,
	TRANS_DUNES_TO_NIGHT_MARKET,
	NIGHT_MARKET,
}

func _ready() -> void:
	_change_state(state.DUNES)
	$Dunes.day_ended.connect(_on_day_ended)


func _change_state(new_state):
	current_state = new_state
	match current_state:
		state.DUNES:
			for child in get_children():
				if child == $Dunes:
					child.show()
				else:
					child.hide()
		state.TRANS_DUNES_TO_NIGHT_MARKET:
			for child in get_children():
				if child == $Transition or child == $Textbox:
					child.show()
				else:
					child.hide()
			$Textbox.set_text("The day is over and you walk a long journey back home.", 
			"You will sell your goods to whoever will buy it.", 
			"They will take some deceiving. Money is not easy to come by.")
		state.NIGHT_MARKET:
			for child in get_children():
				if child == $NightMarket:
					child.show()
				else:
					child.hide()

			var inventory = $Dunes.get_inventory()
			$NightMarket.set_inventory(inventory)


func _on_day_ended():
	_change_state(state.TRANS_DUNES_TO_NIGHT_MARKET)


func _on_textbox_finished_all_text() -> void:
	if current_state == state.TRANS_DUNES_TO_NIGHT_MARKET:
		_change_state(state.NIGHT_MARKET)
		$NightMarket.start()
