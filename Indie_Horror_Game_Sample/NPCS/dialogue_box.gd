extends ColorRect

@export var dialogPath := ""
@export var sound := ""
@export var textSpeed := 0.03

var dialog : Array
var phraseNum := 0
var finished := false
var canReceiveInput := false

signal hasFinished




func _ready():
    if sound != "":
        $AudioLetter.stream = load(sound)
    get_tree().get_first_node_in_group("Player").canMove = false
    get_tree().get_first_node_in_group("Player").velocity = Vector3.ZERO
    
    
    
    $Timer.wait_time = textSpeed
    dialog = getDialog()
    assert(dialog, "Dialog not found")
    nextPhrase()
    
    await get_tree().create_timer(.3).timeout
    canReceiveInput = true


func _process(delta):
    $Indicator.visible = finished
    if canReceiveInput and Input.is_action_just_pressed("interact"):
        if finished:
            nextPhrase()
        else:
            $Text.visible_characters = len($Text.text)





func getDialog():
    var f = FileAccess.open(dialogPath,FileAccess.READ)
    assert(f.file_exists(dialogPath), "File path does not exist")
    
    var json = f.get_as_text()
    var output = JSON.parse_string(json)
    
    if typeof(output) == TYPE_ARRAY:
        return output
    else:
        return []
    

func nextPhrase():
    if phraseNum >= len(dialog):
        get_tree().get_first_node_in_group("Player").canMove = true
        emit_signal("hasFinished")
        queue_free()
        return
    
    finished = false
    $Name.bbcode_text = dialog[phraseNum]["Name"]
    $Text.bbcode_text = dialog[phraseNum]["Text"]
    $Text.visible_characters = 0
    while $Text.visible_characters < len($Text.text):
        $Text.visible_characters += 1
        $Timer.start()
        $AudioLetter.pitch_scale = randf_range(.8,1.2)
        $AudioLetter.play()
        await $Timer.timeout
    
    finished = true
    phraseNum+=1
    return
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
