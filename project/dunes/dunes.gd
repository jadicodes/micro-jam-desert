extends Control

signal day_ended

@export var _items: Array[Item]

const _DAYLIGHT_HOURS = 12

var _chance_of_finding_item: int = 35
var _daylight_hours_remaining: int = _DAYLIGHT_HOURS

var _nothing_texture = preload("res://dunes/nothing_sand.png")
var _normal_texture = preload("res://dunes/dune_button_texture.png")

var inventory: Array[Item]


func _ready() -> void:
	for button in $GridContainer.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))
	start()


func start():
	_reset()


func get_inventory() -> Array[Item]:
	return inventory


func _on_button_pressed(button: TextureButton):
	if _daylight_hours_remaining > 0:
		var buried_item_found = _decide_if_item_exists()
		if buried_item_found == true:
			var index = randi_range(0, _items.size() - 1)
			button.texture_normal = _items[index].texture
			button.disabled = true
			inventory.append(_items[index])
		if buried_item_found == false:
			button.texture_normal = _nothing_texture
			button.disabled = true

		_daylight_hours_remaining -= 1
		_update_daylight_label()
		if _daylight_hours_remaining == 0:
			$EndDayTimer.start()


func _decide_if_item_exists():
	var number = randi_range(1, 100)
	if number > _chance_of_finding_item:
		return false
	if number <= _chance_of_finding_item:
		return true


func _update_daylight_label():
	$DaylightLabel.text = "Daylight Hours Left: " + str(_daylight_hours_remaining)


func _reset():
	for button in $GridContainer.get_children():
		button.texture_normal = _normal_texture
		button.disabled = false
		inventory = []
		_daylight_hours_remaining = _DAYLIGHT_HOURS
		_update_daylight_label()


func _on_end_day_timer_timeout() -> void:
		emit_signal("day_ended")
