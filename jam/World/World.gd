extends Node2D

onready var gameOver = $CanvasLayer/GameOverScreen

func _ready():
	gameOver.hide()

func _on_GameRestart_pressed():
	get_tree().reload_current_scene()
	gameOver.hide()

func _on_Quit_pressed():
	queue_free()
	get_tree().quit()

func _on_Player_death():
	gameOver.show()
