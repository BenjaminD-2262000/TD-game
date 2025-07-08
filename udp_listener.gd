# server_node.gd
class_name ServerNode
extends Node

var server = UDPServer.new()
var peers = []
var pid

# Step tracking
var step_count = 0
var step_start_time = 0.0
var step_length = 0.7 # meters per step (adjust as needed)

func _ready():
	server.listen(4242)
	step_start_time = Time.get_ticks_msec() / 1000.0 # seconds

func _process(delta):
	server.poll()
	
	if server.is_connection_available():
		print("server connected")
		var peer = server.take_connection()
		var packet = peer.get_packet()
		var msg = packet.get_string_from_utf8()
		if msg == "step":
			step_count += 1
		
		peer.put_packet(packet) # Send a reply
		peers.append(peer)

	# Calculate speed every few seconds or as needed
	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - step_start_time
	
	if elapsed_time >= 1.0: # Calculate every second
		var speed = (step_count * step_length) / elapsed_time # m/s
		get_parent().walkingspeed = speed
		# Reset tracking for next interval
		step_count = 0
		step_start_time = current_time


func run_script():
	# Path to your Python script
	var python_script_path = "res://QTM_sender.py"
	var absolute_path = ProjectSettings.globalize_path(python_script_path)

	# Start Python process
	var output = []
	var err = []
	pid = OS.create_process("python", [absolute_path]) #ADD TRUE FOR DEBUG


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		OS.kill(pid)
		get_tree().quit() # default behavior)
