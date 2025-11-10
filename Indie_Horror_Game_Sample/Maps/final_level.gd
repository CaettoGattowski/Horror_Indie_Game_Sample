extends Node


func _on_npc_has_talked_with_me():
    get_tree().change_scene_to_file("res://main_menu.tscn")
