extends Control

var current_state

enum state {
	DUNES,
	NIGHT_MARKET,
}

func _ready() -> void:
	_change_state(state.DUNES)
	$Dunes.day_ended.connect(_on_day_ended)


func _change_state(new_state):
	current_state = new_state
	match current_state:
		state.DUNES:
			$Dunes.show()
			$NightMarket.hide()
		state.NIGHT_MARKET:
			$Dunes.hide()
			$NightMarket.show()
			var inventory = $Dunes.get_inventory()
			$NightMarket.set_inventory(inventory)


func _on_day_ended():
	_change_state(state.NIGHT_MARKET)
