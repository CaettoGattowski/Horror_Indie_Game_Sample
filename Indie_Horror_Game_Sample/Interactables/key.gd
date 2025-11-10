extends Interactable



func action_use():
    AudioStreamManager.play("res://misc_menu_3.wav")
    queue_free()
