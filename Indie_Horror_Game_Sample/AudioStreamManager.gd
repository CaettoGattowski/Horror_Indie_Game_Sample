extends Node

var num_players = 10
var bus = "SFX"

var available = [] #AudioNodos
var queue = []

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		
		p.finished.connect(_on_stream_finished.bind(p))
		
		p.bus = bus

func _on_stream_finished(stream):
	available.append(stream)

func play(sound_path : String):
	queue.append(sound_path)
	

func _process(delta):
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()

