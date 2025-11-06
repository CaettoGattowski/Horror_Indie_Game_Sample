extends CharacterBody3D

#*********NODES**********#
@onready var camera_3d: Camera3D = $Camera3D #press control and grab for instant @onready
@onready var origCamPos: Vector3 = camera_3d.position
@onready var floorcast: RayCast3D = $FloorDetectRayCast
@onready var player_footstep_sound: AudioStreamPlayer2D = $PlayerFootstepSound


#*********CAMERA**********#
var mouse_sens := 0.15

#*********MOVEMENT**********#
var direction
var speed := 3
var jump := 40.0
const GRAVITY = 4

var _delta := 0.0
var camBobSpeed := 5
var camBobUpDown := 1 

var distanceFootstep := 0.0
var playFootstep := 10 # high number slower pace

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    $MeshInstance3D.visible = false
    
func _input(event):
    if event is InputEventMouseMotion:
        rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
        camera_3d.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
        camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
    _process_camBob(delta)
    
    if floorcast.is_colliding():
        var walkingTerrain = floorcast.get_collider().get_parent()
        if walkingTerrain != null:
            var terrainGroup = walkingTerrain.get_groups()[0]
            print(terrainGroup)
            processGroundSounds(terrainGroup)


func processGroundSounds(group : String):
    
    # read state machine in case that you also want the player to play sounds faster or slower
    # depending on if the player is running or crouching
    
    if playFootstep != 100 and (int(velocity.x) != 0) || int(velocity.z) != 0:
        distanceFootstep += .1
    if distanceFootstep > playFootstep and is_on_floor():
        match group:
            "WoodTerrain":
                player_footstep_sound.stream = load("res://Player/SoundsFootsteps/wood/1.ogg")
            "GrassTerrain":
                player_footstep_sound.stream = load("res://Player/SoundsFootsteps/grass/0.ogg")
                
        player_footstep_sound.pitch_scale = randf_range(.8, 1.2)
        player_footstep_sound.play()
        distanceFootstep = 0.0
                

func _physics_process(delta):
    process_movement(delta)
    
    
#*******Movement function*******#
func process_movement(delta):
    direction = Vector3.ZERO
    
    var h_rot = global_transform.basis.get_euler().y
    
    direction.x = -Input.get_action_strength("ui_left") +Input.get_action_strength("ui_right")
    direction.z = -Input.get_action_strength("ui_up") +Input.get_action_strength("ui_down")
    
    direction = Vector3(direction.x, 0, direction.z).rotated(Vector3.UP, h_rot).normalized()
    
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed
    
      
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y += jump
    if !is_on_floor():
        velocity.y -= GRAVITY
        
    
    move_and_slide()

#*******Camera Movement*******#     
func _process_camBob(delta):
    _delta += delta
    
    var cam_bob # speed
    var objCam # how much up and down the camera moves
    if direction != Vector3.ZERO: # player is moving
        cam_bob = floor(abs(direction.z) + abs(direction.x)) * _delta * camBobSpeed
        objCam = origCamPos + Vector3.UP * sin(cam_bob) * camBobUpDown
    else: # player isnt moving
        cam_bob = floor(abs(1) + abs(1)) * _delta * .5
        objCam = origCamPos + Vector3.UP * sin(cam_bob) * camBobUpDown * .1
    
    camera_3d.position = camera_3d.position.lerp(objCam, delta) #lerp for smooth movement
