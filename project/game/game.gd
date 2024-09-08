extends Control

var current_state
const MARKET_TO_DUNES = preload("res://game/market_to_dunes.png")
const DUNES_TO_MARKET = preload("res://game/dunes_to_market.png")


enum state {
	INTRO,
	DUNES,
	TRANS_DUNES_TO_NIGHT_MARKET,
	NIGHT_MARKET,
	TRANS_NIGHT_MARKET_TO_DUNES,
}

func _ready() -> void:
	_change_state(state.DUNES)
	$Dunes.day_ended.connect(_on_day_ended)


func _change_state(new_state):
	current_state = new_state
	match current_state:
		state.INTRO:
			pass
		state.DUNES:
			for child in get_children():
				if child == $Dunes:
					child.show()
				else:
					child.hide()
			$Dunes.start() 
		state.TRANS_DUNES_TO_NIGHT_MARKET:
			for child in get_children():
				if child == $Transition or child == $Textbox:
					$Transition.texture = DUNES_TO_MARKET
					child.show()
				else:
					child.hide()
			$Textbox.set_text("The day is over and you walk a long journey back home. You will sell your goods to whoever will buy it. They will take some deceiving. Money is not easy to come by.")
		state.NIGHT_MARKET:
			for child in get_children():
				if child == $NightMarket:
					child.show()
				else:
					child.hide()
			var inventory = $Dunes.get_inventory()
			$NightMarket.set_inventory(inventory)
		state.TRANS_NIGHT_MARKET_TO_DUNES:
			for child in get_children():
				if child == $Transition or child == %Textbox:
					$Transition.texture = MARKET_TO_DUNES
					child.show()
				else:
					$NightMarket.hide()
					child.hide()
			$Textbox.set_text("You must go to the dunes again tomorrow.")


func _on_day_ended():
	_change_state(state.TRANS_DUNES_TO_NIGHT_MARKET)


func _on_textbox_finished_all_text() -> void:
	if current_state == state.TRANS_DUNES_TO_NIGHT_MARKET:
		_change_state(state.NIGHT_MARKET)
		$NightMarket.start()
	if current_state == state.TRANS_NIGHT_MARKET_TO_DUNES:
		_change_state(state.DUNES)


func _on_night_market_night_ended() -> void:
	_change_state(state.TRANS_NIGHT_MARKET_TO_DUNES)
