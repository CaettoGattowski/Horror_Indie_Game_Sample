extends Node

var totalCollectedKeys := 0
var keysToFinish := 1
func _ready():
    keysToFinish = $Keys.get_children().size()
    $GUIContainerKeys/LabelTotalKeys.text = str($Keys.get_children().size())
    
    for key in $Keys.get_children():
        key.connect("collectedKey",keyCollected)


func keyCollected():
    totalCollectedKeys += 1
    $GUIContainerKeys/LabelCurrentKeys.text = str(totalCollectedKeys)
    $collectedSound.play()
    print(str(keysToFinish))
    if totalCollectedKeys >= keysToFinish:
        get_tree().change_scene_to_file("res://Maps/final_level.tscn")
    
    
    
