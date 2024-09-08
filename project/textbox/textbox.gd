class_name Textbox
extends CanvasLayer

signal finished_all_text

const CHAR_READ_RATE = 0.03

enum state {
	READY,
	READING,
	FINISHED
}

var current_state = state.READY
var _tween

@onready var _textbox = %TextboxContainer
@onready var _start_symbol = %StartSymbol
@onready var _text = %Label
@onready var _end_symbol = %EndSymbol


# Manages player input

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if current_state == state.FINISHED:
			_change_state(state.READY)
			finished_all_text.emit()

		elif current_state == state.READING:
			_change_state(state.FINISHED)


func set_text(text) -> void:
	_text.text = text
	show_textbox()
	_tween = create_tween()
	_tween.tween_property(_text, "visible_ratio", 1.0, len(text) * CHAR_READ_RATE).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	_tween.connect("finished", _on_tween_finished)
	_change_state(state.READING)


# Show and hide textbox

func show_textbox() -> void:
	_start_symbol = "*"
	_textbox.show()


func hide_textbox() -> void:
	_text.visible_ratio = 0.0
	_textbox.hide()


# Manages state of the textbox 

func _change_state(new_state) -> void: 
	current_state = new_state
	match current_state:
		state.READY:
			_text.visible_ratio = 0.0
		state.READING:
			_tween.play()
			_end_symbol.text = ".."
		state.FINISHED:
			_end_symbol.text = "*"
			_text.visible_ratio = 1.0
			_tween.pause()


# Manages signal received from tween finishing

func _on_tween_finished() -> void:
	_change_state(state.FINISHED)
