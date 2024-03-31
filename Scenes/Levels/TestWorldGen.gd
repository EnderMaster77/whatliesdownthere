@tool
extends Node2D
var enemyfab : PackedScene = preload("res://Scenes/Characters/Enemy/BasicEnemy.tscn")
var playerfab : PackedScene = preload("res://Scenes/Characters/Player/character.tscn")
var tppad : PackedScene = preload("res://Scenes/Extras/TPPad.tscn")

signal finished

@export var enemy_weapons: Array = [preload("res://Scenes/Weapons/Pistols/1911.tscn")]

@onready var tilemap: TileMap = $TileMap

@export var start: bool = false : set = set_start
func set_start(val:bool)-> void:
	generate(Vector2i(0,0),Vector2i(0,0),enemy_weapons[0],enemy_weapons[1])
	$Bordertimer.start()

#@export var make_border: bool = false : set = generate_border



@export_range(0,1) var survival_chance: float = 0.25

@export var border_size: int = 20 : set = set_border_size

@export var hallway_style := AStarGrid2D.HEURISTIC_MANHATTAN


func set_border_size(val: int) -> void:
	border_size = val
	if Engine.is_editor_hint():
		visualize_border()
	
@export var room_number: int = 5
@export var room_margin: int = 1
@export var room_recursion: int = 15
@export var min_room_size : int = 8
@export var max_room_size: int = 20

@export var min_enemies_per_room: int = 1
@export var max_enemies_per_room: int = 4

var floortile
var walltile

var room_tiles: Array[PackedVector2Array] = []
var room_positions: PackedVector2Array = []
	 
func visualize_border():
	tilemap.clear()
	for i in range(-1, border_size+1):
		tilemap.set_cell(0,Vector2i(i,border_size), 0, Vector2i(1,1))
		tilemap.set_cell(0,Vector2i(i,-1), 0, Vector2i(1,1))
		tilemap.set_cell(0,Vector2i(border_size,i), 0, Vector2i(1,1))
		tilemap.set_cell(0,Vector2i(-1,i), 0, Vector2i(1,1))
func generate_border(val: bool, wall_tile: Vector2i):
	var past_cells = tilemap.get_used_cells(0)
	for i in past_cells:
		var neighbor = Vector2i(i.x, i.y-1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x+1, i.y-1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x+1, i.y)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x+1, i.y+1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x, i.y+1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x-1, i.y+1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x-1, i.y)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
		neighbor = Vector2i(i.x-1, i.y-1)
		if tilemap.get_cell_tile_data(0,neighbor) == null:
			tilemap.set_cell(0,neighbor,0,wall_tile)
func generate(floor_tile: Vector2i, wall_tile: Vector2i,gun1:PackedScene,gun2:PackedScene):
	walltile = wall_tile
	floortile = floor_tile
	print(floortile)
	room_tiles.clear()
	room_positions.clear()
	for child in tilemap.get_children():
		child.queue_free()
	var t : int = 0
	tilemap.clear()
	#visualize_border()
	for i in room_number:
		t+=1
		make_room(room_recursion, t, gun1,gun2)
		if t%17 == 16: await get_tree().create_timer(0).timeout
	
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()
	
	for p in room_positions:
		del_graph.add_point(del_graph.get_available_point_id(),Vector2(p.x,p.y))
		mst_graph.add_point(mst_graph.get_available_point_id(),Vector2(p.x,p.y))
	
	var delaunay : Array = Array(Geometry2D.triangulate_delaunay(room_positions))
	for i in delaunay.size()/3:
		var p1 : int = delaunay.pop_front()
		var p2 : int = delaunay.pop_front()
		var p3 : int = delaunay.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)
	
	var visited_points : PackedInt32Array = []
	visited_points.append(randi() % room_positions.size())
	while visited_points.size() != mst_graph.get_point_count():
		var possible_connections : Array[PackedInt32Array] = []
		for vp in visited_points:
			for c in del_graph.get_point_connections(vp):
				if !visited_points.has(c):
					var con : PackedInt32Array = [vp,c]
					possible_connections.append(con)
					
		var connection : PackedInt32Array = possible_connections.pick_random()
		for pc in possible_connections:
			if room_positions[pc[0]].distance_squared_to(room_positions[pc[1]]) <\
			room_positions[connection[0]].distance_squared_to(room_positions[connection[1]]):
				connection = pc
		
		visited_points.append(connection[1])
		mst_graph.connect_points(connection[0],connection[1])
		del_graph.disconnect_points(connection[0],connection[1])
	
	var hallway_graph : AStar2D = mst_graph
	
	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c>p:
				var kill : float = randf()
				if survival_chance > kill :
					hallway_graph.connect_points(p,c)
					
	create_hallways(hallway_graph, floor_tile)
	
func create_hallways(hallway_graph:AStar2D, floor_tile):
	var hallways : Array[PackedVector2Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var room_from : PackedVector2Array = room_tiles[p]
				var room_to : PackedVector2Array = room_tiles[c]
				var tile_from : Vector2 = room_from[0]
				var tile_to : Vector2 = room_to[0]
				for t in room_from:
					if t.distance_squared_to(room_positions[c])<\
					tile_from.distance_squared_to(room_positions[c]):
						tile_from = t
				for t in room_to:
					if t.distance_squared_to(room_positions[p])<\
					tile_to.distance_squared_to(room_positions[p]):
						tile_to = t
				var hallway : PackedVector2Array = [tile_from,tile_to]
				hallways.append(hallway)
				tilemap.set_cell(0,tile_from, 0, floor_tile)
				tilemap.set_cell(0,tile_to, 0, floor_tile)
	
	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.region= Rect2i(0,0,Vector2i.ONE.x * border_size, Vector2i.ONE.y * border_size)
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = hallway_style
	
	for t in tilemap.get_used_cells_by_id(0,0,Vector2i(4,2)):#.get_used_cells_by_item(0):
		astar.set_point_solid(t)
	var _t : int = 0
	for h in hallways:
		_t +=1
		var pos_from : Vector2i = Vector2i(h[0].x,h[0].y)
		var pos_to : Vector2i = Vector2i(h[1].x,h[1].y)
		astar.update()
		var hall = astar.get_id_path(pos_from, pos_to)
		var time: int = 0
		for t in hall:
			if tilemap.get_cell_tile_data(0,t) == null:
				tilemap.set_cell(0,t, 0,floor_tile)
			var neighbor = Vector2i(t.x, t.y-1)
			if tilemap.get_cell_tile_data(0,neighbor) == null:
				tilemap.set_cell(0,neighbor,0,floor_tile)
			neighbor = Vector2i(t.x+1, t.y)
			if tilemap.get_cell_tile_data(0,neighbor) == null:
				tilemap.set_cell(0,neighbor,0,floor_tile)
			neighbor = Vector2i(t.x, t.y+1)
			if tilemap.get_cell_tile_data(0,neighbor) == null:
				tilemap.set_cell(0,neighbor,0,floor_tile)
			neighbor = Vector2i(t.x-1, t.y)
			if tilemap.get_cell_tile_data(0,neighbor) == null:
				tilemap.set_cell(0,neighbor,0,floor_tile)
		time += 1
		if _t%16 == 15: await  get_tree().create_timer(0).timeout

func make_room(rec:int,room_num:int, gun1,gun2):
	if !rec>0:
		return
	
	var width : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	var height : int = (randi() % (max_room_size - min_room_size)) + min_room_size
	
	var start_pos : Vector2i 
	start_pos.x = randi() % (border_size - width + 1)
	start_pos.y = randi() % (border_size - height + 1)
	
	for r in range(-room_margin,height+room_margin):
		for c in range(-room_margin,width+room_margin):
			var pos : Vector2i = start_pos + Vector2i(c,r)
			if tilemap.get_cell_tile_data(0, pos):
				make_room(rec-1,room_num,gun1,gun2)
				return
	
	var room : PackedVector2Array = []
	for r in height:
		for c in width:
			var pos : Vector2i = start_pos + Vector2i(c,r)
			tilemap.set_cell(0,pos, 0, floortile)
			room.append(pos)
	room_tiles.append(room)
	var avg_x : float = start_pos.x + (float(width)/2)
	var avg_y : float = start_pos.y + (float(height)/2)
	var pos : Vector2 = Vector2(avg_x,avg_y)
	room_positions.append(pos)
	var enemies_spawned: int = 0
	var enemies_in_room: int = randi_range(min_enemies_per_room,max_enemies_per_room)
	while enemies_in_room != enemies_spawned:
		for i in room:
			if enemies_in_room == enemies_spawned:
				continue
			if randf() > 0.99:
				spawn_enemy(i, gun1, gun2)
				enemies_spawned += 1

func spawn_enemy(location: Vector2i, gun1, gun2):
	var enemy = enemyfab.instantiate()
	var weapon
	print(gun1," ",gun2)
	if randf() > .50:
		weapon = gun1.instantiate()
	else:
		weapon = gun2.instantiate()
	print(weapon)
	enemy.player = $Character
	weapon.trackedNode = $Character
	enemy.position = tilemap.map_to_local(location)
	enemy.scale = enemy.scale / tilemap.scale
	weapon.player_weapon = false
	enemy.add_child(weapon)
	tilemap.add_child(enemy)


func _on_bordertimer_timeout() -> void:
	generate_border(true, walltile)
	var pointa: Vector2i = Vector2i.ZERO
	var pointb: Vector2i = Vector2i.ZERO
	var distance: float = 0
	for point1 in room_positions:
		for point2 in room_positions:
			if point1.distance_squared_to(point2) > distance:# && pointa != pointb:
				distance = point1.distance_squared_to(point2)
				pointa = point1
				pointb = point2
	
	var spawnpoint = Node2D.new()
	var bosspoint = Node2D.new()
	bosspoint.position = tilemap.map_to_local(pointb)
	spawnpoint.position = tilemap.map_to_local(pointa)
	tilemap.add_child(spawnpoint)
	tilemap.add_child(bosspoint)
	$PORTALBACK.global_position = bosspoint.global_position
	if Engine.is_editor_hint() == false:
		#$TpPad.global_position = bosspoint.global_position
		$TPTOLEVEL.target_location = spawnpoint.global_position
		$TPTOLEVEL2.target_location = spawnpoint.global_position
		$TPTOLEVEL3.target_location = spawnpoint.global_position
		$TPTOLEVEL4.target_location = spawnpoint.global_position
		$TPTOLEVEL5.target_location = spawnpoint.global_position
		$TPTOLEVEL6.target_location = spawnpoint.global_position
		$TPTOLEVEL2.show()
		$TPTOLEVEL3.show()
		$TPTOLEVEL4.show()
		$TPTOLEVEL5.show()
		$TPTOLEVEL5.show()
		$TPTOLEVEL6.show()
		$TPTOLEVEL.show()
		
		finished.emit()
	for child in $TileMap.get_children():
		if child.is_in_group("Enemy"):
			if sqrt(child.global_position.distance_squared_to(spawnpoint.global_position)) < 2000:
				child.queue_free()
	

	
