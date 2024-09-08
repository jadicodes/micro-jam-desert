extends Control


var _current_state: int
var _item_being_sold: Item
var _inventory_index: int

var _fun_option: String
var _practical_option: String
var _evil_option: String

enum state {
	BUYER_ARRIVES,
	MAKE_PITCH,
	SUCCESS,
	FAILURE,
	NIGHT_OVER
}

var inventory: Array[Item]
@export var _buyers: Array[Buyer]


func _ready():
	$Textbox.hide()


func start():
	$Textbox.show()
	_change_state(state.BUYER_ARRIVES)


func set_inventory(new_inventory: Array[Item]):
	inventory = new_inventory


func _set_item_being_sold():
	if inventory[_inventory_index] == null:
		_change_state(state.NIGHT_OVER)

	_item_being_sold = inventory[_inventory_index]
	%ItemBeingSoldTexture.texture = _item_being_sold.texture
	_fun_option = _item_being_sold.fun_name
	_practical_option = _item_being_sold.practical_name
	_evil_option = _item_being_sold.evil_name


func _change_state(new_state):
	_current_state = new_state
	match _current_state:
		state.BUYER_ARRIVES:
			# Animation
			_set_item_being_sold()
			%AnimationPlayer.play("hand_enters")



func _reset():
	_inventory_index = 0
	inventory = []


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hand_enters":
		%AnimationPlayer.play("buyer_enters")
	if anim_name == "buyer_enters":
		$Textbox.set_text("I would like to buy that. What is it?")
	


func _on_textbox_finished_all_text() -> void:
	if _current_state == state.BUYER_ARRIVES:
		pass
		# Show options
