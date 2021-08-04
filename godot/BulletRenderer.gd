extends MultiMeshInstance2D


func _ready():
	#multimesh.color_format = MultiMesh.COLOR_NONE
	#multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
		
	for i in multimesh.instance_count:
		multimesh.set_instance_transform_2d(i, Transform2D(0, Vector2(-1000,-1000)))
	
	
