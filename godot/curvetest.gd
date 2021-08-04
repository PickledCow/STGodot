extends MeshInstance2D


var nodes = [Vector2(64, 64), Vector2(256, 64), Vector2(300, 300),Vector2(300, 500), Vector2(200, 600)]

func generate_verts(nodes, m):
	var tex_rect = Rect2(0, 0.625, 0.0312, 0.25)
	
	var step = 1.0/len(nodes)
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in range(1, len(nodes)-1):
		var a = nodes[i-1]
		var b = nodes[i]
		var c = nodes[i+1]
		var dir = (b-c).normalized()
		var u1 = a - b
		var v1 = c - b
		var s1 = (u1.length() * v1 + v1.length() * u1).normalized() * 64#Vector2(-dir.y, dir.x)
		#(u1.length() * v1 + v1.length() * u1).rotated(-angle + PI/2)
		var s2 = -s1
		var uv = Vector2(0, i * step)
		var true_uv = tex_rect.position + Vector2(0, tex_rect.size.y * uv.y) 
		st.add_uv(true_uv)
		var ass = b + s1
		st.add_vertex(Vector3(ass.x, ass.y, 0))
		
		st.add_uv(true_uv + Vector2(tex_rect.size.x, 0))
		var tits = b + s2
		st.add_vertex(Vector3(tits.x, tits.y, 0))
	st.commit(m, 97280 + 262144)
	
var arrmesh

func _ready():
	arrmesh = ArrayMesh.new()
	generate_verts(nodes, arrmesh)

func _process(delta):
	var surface_count = arrmesh.get_surface_count()
	for i in surface_count:
		arrmesh.surface_remove(surface_count-1 - i)
		generate_verts(nodes, arrmesh)
	update()

func _draw():
	draw_mesh(arrmesh, texture)
	
	
