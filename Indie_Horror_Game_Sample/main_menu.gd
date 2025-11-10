extends Node3D

func _ready():
    Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
    $AudioStreamPlayer.play()


func _on_start_game_button_pressed():
    get_tree().change_scene_to_file("res://Maps/level_1.tscn")




func _on_exit_game_button_pressed():
    get_tree().quit()


func _on_fullscreen_button_pressed():
    if DisplayServer.window_get_mode() == 0:
        DisplayServer.window_set_mode(3)
    elif DisplayServer.window_get_mode() == 3:
        DisplayServer.window_set_mode(0)
