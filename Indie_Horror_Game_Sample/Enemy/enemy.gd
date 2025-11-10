extends CharacterBody3D
@onready var nav_agent : NavigationAgent3D = $NavAgent

var speed := 3
var navRange := 50
var target_location : Vector3

enum STATES {Roam, Chase}
var currentState = STATES.Roam
var player : Player
var lookAtVar = Vector3.ZERO

func _ready():
    randomize()
    get_roam_location()

func get_roam_location():
    var nextLocation = Vector3.ZERO
    while nextLocation == Vector3.ZERO:
        nextLocation = roamLocation()
        print("Try for next location",nextLocation)

func roamLocation() -> Vector3:
    var origPos = global_position
    target_location = Vector3(origPos.x+(navRange * randf_range(-1.0,1.0)), 
                            origPos.y,
                            origPos.z+(navRange * randf_range(-1.0,1.0)))
    nav_agent.set_target_position(target_location)
    print(target_location, " as The target location, Is it Reachable? ",nav_agent.is_target_reachable())
    
    if nav_agent.is_target_reachable():
        return target_location
    else:
        return Vector3.ZERO


func _physics_process(delta):
    if currentState == STATES.Roam:
        
        if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
            var next_location = nav_agent.get_next_path_position()
            velocity = global_position.direction_to(next_location) * speed
            if !is_on_floor():
                velocity.y -= 10
            move_and_slide()
            lookAtVar = lookAtVar.lerp(Vector3(next_location.x, 0, next_location.z), .1)
            look_at(lookAtVar)
            rotation.x = 0
        else:
            print("Target reached or not reachable")
            get_roam_location()
    if currentState == STATES.Chase:
        velocity = global_position.direction_to(player.global_position) * speed * 2.5
        lookAtVar = lookAtVar.lerp(Vector3(player.global_position.x,0,player.global_position.z),.1)
        look_at(lookAtVar)
        if !is_on_floor():
            velocity.y -= 10
        move_and_slide()



func _on_detect_player_body_entered(body):
    if body is Player:
        print("Player detected")
        currentState = STATES.Chase
        player = body
        $TimerToRoam.start()


func _on_timer_to_roam_timeout():
    print("State now is Roam")
    currentState = STATES.Roam


func _on_kil_player_body_entered(body):
    if body is Player:
        get_tree().change_scene_to_file("res://Maps/kill_scene.tscn")
