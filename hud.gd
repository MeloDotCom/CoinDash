extends CanvasLayer 

signal start_game 

func update_score(value): 
	$MarginContainer/Score.text = str(value) 
	
func update_timer(value): 
	$MarginContainer/Timer.text = str(value)

func show_message(text):
	$Message.text = text
	$Message.show()
	$Nome.text = text
	$Nome.show()
	$Timer.start()
	
	
func _on_timer_timeout() -> void:
	$Message.hide()
	$Nome.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	$Nome.hide()
	start_game.emit()
	
func show_game_over():
	$Message.text = "GAME OVER"
	$Message.show()
	await get_tree().create_timer(2.0).timeout
	$StartButton.show()
	$Message.text = ("Coin Dash!")
	$Message.show()
	$Nome.text = ("Caua Melo")
	$Nome.show()
