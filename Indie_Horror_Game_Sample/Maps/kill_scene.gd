extends Node


func _on_kilscene_animation_player_animation_finished(anim_name):
    get_tree().change_scene_to_file("res://Maps/level_5.tscn")
