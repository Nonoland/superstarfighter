tool
extends Line2D

export var path_star_scene: PackedScene
export var path_line_scene: PackedScene

export var unlocked := false

const D = 25

func set_points(v):
	points = v
	refresh()
	
func _ready():
	refresh()
	if unlocked:
		# wait for tree to be refreshed
		yield(get_tree(), "idle_frame")
		appear()
	
func refresh():
	for child in $Content.get_children():
		child.queue_free()
		
	# add a smaller line to each segment
	for i in range(len(points)-1):
		add_line(points[i], points[i+1])
		
		# add a star to each internal corner
		if i < len(points)-2:
			var star = path_star_scene.instance()
			star.position = points[i+1]
			$Content.add_child(star)

func add_line(p1, p2):
	var dir = (p2-p1).normalized()
	
	var line = path_line_scene.instance()
	line.set_endpoints(p1+dir*D, p2-dir*D)
	$Content.add_child(line)

func get_global_endpoints() -> Dictionary: # Dictionary {start: Vector2, end: Vector2}
	return {
		'start': to_global(points[0]),
		'end': to_global(points[-1])
	}

func appear() -> void:
	for child in $Content.get_children():
		child.appear()
		yield(child, 'appeared')
		