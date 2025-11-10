extends Interactable

@export var dialogPath := ""
@export var sound := ""
@onready var DialogueScene = preload("res://NPCS/dialogue_box.tscn")

signal hasTalkedWithMe
var hasSignalEmmited = false
var hasDialogueStarted = false

func action_use():
    if !hasDialogueStarted:
        hasDialogueStarted = true
        var dialogScene = DialogueScene.instantiate()
        dialogScene.dialogPath = self.dialogPath
        dialogScene.sound = self.sound
        dialogScene.hasFinished.connect(dialogueFinished)
        add_child(dialogScene)

func dialogueFinished():
    if !hasSignalEmmited:
        hasSignalEmmited = true
        emit_signal("hasTalkedWithMe")
    hasDialogueStarted = false
