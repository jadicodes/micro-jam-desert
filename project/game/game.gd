extends Control

var current_state
var _has_enough_bones: bool

const MARKET_TO_DUNES = preload("res://game/market_to_dunes.png")
const DUNES_TO_MARKET = preload("res://game/dunes_to_market.png")
const INTRO = preload("res://game/intro.png")
const ENDING = preload("res://game/ending.png")

var _days: int = 0
const _DAYS_TOTAL: int = 3


enum state {
	INTRO,
	INTRO2,
	DUNES,
	TRANS_DUNES_TO_NIGHT_MARKET,
	NIGHT_MARKET,
	TRANS_NIGHT_MARKET_TO_DUNES,
	DETERMINE_OUTCOME,
}

func _ready() -> void:
	_change_state(state.INTRO)
	$Dunes.day_ended.connect(_on_day_ended)
	SFX.play_desert_song()


func _change_state(new_state):
	current_state = new_state
	match current_state:
		state.INTRO:
			for child in get_children():
				if child == $Transition or child == $Textbox:
					$Transition.texture = INTRO
					child.show()
				else:
					child.hide()
			$Textbox.set_text("Your desert village is doomed. Resources are scarce. Your only option is to flee before the Terrible Ones take over in 3 days.")
		state.INTRO2:
			$Transition.texture = MARKET_TO_DUNES
			$Textbox.set_text("Relocation costs 100 bones. You know of an old dune that once belonged to a now ancient society. Selling their relics is the only way to make enough money to escape.")
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
			$Textbox.set_text("The day is over and you take the long journey back home. You will sell your goods to whoever will buy it. You must tell whatever lie is necessary to get them to part with their bones.")
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
		state.DETERMINE_OUTCOME:
			for child in get_children():
				if child == $Transition or child == %Textbox:
					$Transition.texture = MARKET_TO_DUNES
					child.show()
				else:
					$NightMarket.hide()
					child.hide()
			$Transition.texture = INTRO
			$Textbox.set_text("It is the end. Tomorrow, your village will be overtaken by the Terrible Ones. You count up your bones...")
			if $NightMarket.get_bones() >= 100:
				_has_enough_bones = true
			else:
				_has_enough_bones = false


func _on_day_ended():
	_change_state(state.TRANS_DUNES_TO_NIGHT_MARKET)


func _on_textbox_finished_all_text() -> void:
	if current_state == state.TRANS_DUNES_TO_NIGHT_MARKET:
		_change_state(state.NIGHT_MARKET)
		$NightMarket.start()
	if current_state == state.TRANS_NIGHT_MARKET_TO_DUNES:
		_change_state(state.DUNES)
	if current_state == state.INTRO2:
		_change_state(state.DUNES)
	if current_state == state.INTRO:
		_change_state(state.INTRO2)
	if current_state == state.DETERMINE_OUTCOME:
		$Transition.texture = ENDING
		if _has_enough_bones:
			$Textbox.set_text("The village is doomed. Fortunately, you only see it from a distance. You paid the relocation fee and walk far into the distance with your family at your side. You thank your lucky sand dune as you go.")
		else:
			$Textbox.set_text("The village is doomed. You did not have enough bones, and they will not let you leave. Good night.")


func _on_night_market_night_ended() -> void:
	_days += 1
	if _days != _DAYS_TOTAL:
		_change_state(state.TRANS_NIGHT_MARKET_TO_DUNES)
	else:
		_change_state(state.DETERMINE_OUTCOME)
