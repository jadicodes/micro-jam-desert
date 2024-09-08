extends CanvasLayer


signal fun_pressed
signal practical_pressed
signal evil_pressed


func set_fun_text(text):
	%FunButton.text = text


func set_evil_text(text):
	%EvilButton.text = text


func set_practical_text(text):
	%PracticalButton.text = text


func _on_fun_button_pressed() -> void:
	emit_signal("fun_pressed")


func _on_practical_button_pressed() -> void:
	emit_signal("practical_pressed")


func _on_evil_button_pressed() -> void:
	emit_signal("evil_pressed")
