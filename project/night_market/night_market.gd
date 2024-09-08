extends Control

signal night_ended

var _current_state: int
var _item_being_sold: Item
var _inventory_index: int

var _fun_option: String
var _practical_option: String
var _evil_option: String

var number_of_bones: int = 0

enum state {
	SHOP_RESET,
	BUYER_ARRIVES,
	MAKE_PITCH,
	SUCCESS,
	FAILURE,
	BUYER_LEAVES,
	NIGHT_OVER
}

var inventory: Array[Item]

@export var _buyers: Array[Buyer]
var _current_buyer: Buyer
var _buyer_preference: int


func _ready():
	$Textbox.hide()
	%Options.hide()


func start():
	SFX.fade_to_market_music()
	$Textbox.show()
	_buyers.shuffle()
	_set_item_being_sold()
	_set_buyer()
	$Textbox.set_text("")
	_change_state(state.SHOP_RESET)

# Setters

func set_inventory(new_inventory: Array[Item]):
	inventory = new_inventory


func _set_item_being_sold():
	_item_being_sold = inventory[_inventory_index]
	%ItemBeingSoldTexture.texture = _item_being_sold.texture
	_fun_option = _item_being_sold.fun_name
	_practical_option = _item_being_sold.practical_name
	_evil_option = _item_being_sold.evil_name


func _set_buyer():
	_current_buyer = _buyers[_inventory_index]
	$Buyer.texture = _current_buyer.texture
	_buyer_preference = _current_buyer.item_preference


# Manage Night Market state

func _change_state(new_state):
	_current_state = new_state
	match _current_state:
		state.SHOP_RESET:
			if _inventory_index == inventory.size():
				_change_state(state.NIGHT_OVER)
			else:
				_set_item_being_sold()
				print(_item_being_sold.name)
				$Textbox.set_text("")
				%ArmAnimationPlayer.play("hand_enters")
		state.BUYER_ARRIVES:
			_set_buyer()
			$Textbox.set_text(_current_buyer.text)
			%BuyerAnimationPlayer.play("buyer_enters")
		state.MAKE_PITCH:
			%Options.show()
			%Options.set_fun_text(_item_being_sold.fun_name)
			%Options.set_practical_text(_item_being_sold.practical_name)
			%Options.set_evil_text(_item_being_sold.evil_name)
		state.SUCCESS:
			_sale_finalized(true)
			number_of_bones += 10
			_update_bones_label()
			SFX.play_bones_got_sound()
		state.FAILURE:
			_sale_finalized(false)
			SFX.play_sad_customer_sound()
		state.BUYER_LEAVES:
			%BuyerAnimationPlayer.play("buyer_exits")
			%ArmAnimationPlayer.play("hand_exits")
		state.NIGHT_OVER:
			SFX.fade_to_desert_music()
			$Textbox.set_text("The market ends. You are out of items to sell.")


func _reset():
	_inventory_index = 0
	inventory = []
	$Textbox.hide()


func _update_bones_label():
	$Label.text = ("You have " + str(number_of_bones) + " bones.")


func _on_textbox_finished_all_text() -> void:
	if _current_state == state.BUYER_ARRIVES:
		_change_state(state.MAKE_PITCH)
	if _current_state == state.SUCCESS or _current_state == state.FAILURE:
		_change_state(state.BUYER_LEAVES)
	if _current_state == state.NIGHT_OVER:
		_reset()
		emit_signal("night_ended")


# Determine if button pressed was a good choice

func _on_options_evil_pressed() -> void:
	_decide_if_sale_successful(2)


func _on_options_fun_pressed() -> void:
	_decide_if_sale_successful(0)


func _on_options_practical_pressed() -> void:
	_decide_if_sale_successful(1)


func _decide_if_sale_successful(choice: int):
	if choice == _buyer_preference:
		_change_state(state.SUCCESS)
	else:
		_change_state(state.FAILURE)


func _sale_finalized(has_succeeded: bool):
	%Options.hide()
	_inventory_index += 1
	if has_succeeded == true:
		$Textbox.set_text(_current_buyer.happy_customer_text)
	else:
		$Textbox.set_text(_current_buyer.dissappointed_text)


# Animation player state changes

func _on_buyer_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "buyer_exits":
		_change_state(state.SHOP_RESET)


func _on_arm_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hand_enters":
		_change_state(state.BUYER_ARRIVES)
