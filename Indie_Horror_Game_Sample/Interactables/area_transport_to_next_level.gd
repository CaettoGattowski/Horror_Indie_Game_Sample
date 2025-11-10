extends Area3D
@export var pathToNextLevel : String




func _on_body_entered(body):
    if body is Player and pathToNextLevel != "":
        get_tree().change_scene_to_file(pathToNextLevel)
    else:
        assert(!pathToNextLevel == "","Fill the path to next level because it's empty")
