extends Control


var _current_state: int
var _item_being_sold: Item
var _inventory_index: int

enum state {
	BUYER_ARRIVES,
	MAKE_PITCH,
	SUCCESS,
	FAILURE
}

var inventory: Array[Item]


func set_inventory(new_inventory: Array[Item]):
	inventory = new_inventory


func _set_item_being_sold():
	%ItemBeingSoldTexture.texture = _item_being_sold.texture


func _change_state(new_state):
	_current_state = new_state
	match _current_state:
		state.BUYER_ARRIVES:
			# Animation
			_set_item_being_sold()
