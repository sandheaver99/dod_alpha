extends Node2D

var left_counters = [Vector2(80,240), Vector2(80,320)]
var bottom_counters = [Vector2(160,400), Vector2(240,400)]


func _ready():
	
	build()
	
func build():
	#Prep main assets
	var counter_asset = load("res://scenes/counter/Counter.tscn")
	var board_asset = load("res://scenes/board/Board.tscn")
	board_asset = board_asset.instance()
	
	call_deferred("add_child", board_asset)
	
	#Place left counters
	var call = 0
	for counter in left_counters:
		counter_asset = counter_asset.instance()
		counter_asset.set_pos(counter)
		counter_asset.get_child(0).set_offset(counter)
		counter_asset.get_child(0).set_board_index((call*4) + 4)
		counter_asset.get_child(0).set_type(global.left_counter_type)
		counter_asset.get_child(0).get_child(0).set_modulate(Color('#FF6347'))
		call_deferred("add_child", counter_asset)
		global.board_array[0][call] = global.left_counter_type
		call += 1
		counter_asset = load("res://scenes/counter/Counter.tscn")
		
	
	#Place bottom counters
	call = 0
	for counter in bottom_counters:
		counter_asset = counter_asset.instance()
		counter_asset.set_pos(counter)
		counter_asset.get_child(0).set_offset(counter)
		counter_asset.get_child(0).set_playable(false)
		counter_asset.get_child(0).set_board_index(call + 13)
		counter_asset.get_child(0).set_type(global.bottom_counter_type)
		counter_asset.get_child(0).get_child(0).set_modulate(Color('#00bfff'))
		call_deferred("add_child", counter_asset)
		global.board_array[call+1][2] = global.bottom_counter_type
		call += 1
		counter_asset = load("res://scenes/counter/Counter.tscn")
		
	
		