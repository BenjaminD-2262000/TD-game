extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

##only works on gltf sketchfab models
func set_transparent(transparency: float):
	
	var meshes = get_children()[0].get_children()[0].get_children()[0].get_children()
	set_transparent_helper(transparency, meshes)

func set_transparent_helper(transparency: float, meshes):
	for mesh in meshes:
		if mesh.get_children():
			set_transparent_helper(transparency, mesh.get_children())
		else:
			if mesh is MeshInstance3D:
				mesh.transparency = transparency
