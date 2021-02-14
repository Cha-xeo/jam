extends Node2D

onready var gameOver = $CanvasLayer/GameOverScreen
func _ready():
	gameOver.hide()

func _process(delta):
	if Input.is_action_pressed("ui_cancel"): #escape à changer par la conditio de defaite
		gameOver.show()

func _on_GameRestart_pressed():
	print("restart the game")
	gameOver.hide()


func _on_Quit_pressed():
	queue_free()
	get_tree().quit()
