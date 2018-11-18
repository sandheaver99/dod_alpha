extends Node

var squares_for_counters = [[
	#bottom
	Vector2(80,160),Vector2(160,160),Vector2(240,160),
	Vector2(80,240),Vector2(160,240),Vector2(240,240),
	Vector2(80,320),Vector2(160,320),Vector2(240,320),
	Vector2(80,400),Vector2(160,400),Vector2(240,400)],[
	
	#top
	Vector2(80,240),Vector2(160,240),Vector2(240,240),Vector2(320,240),
	Vector2(80,320),Vector2(160,320),Vector2(240,320),Vector2(320,320),
	Vector2(80,400),Vector2(160,400),Vector2(240,400),Vector2(320,400)]]

var board_array
var height = 3
var width = 3
var play_with_computer = false
var left_counter_type = 2
var bottom_counter_type = 1


func _ready():
	
	board_array = []
	for x in range(width):
		board_array.append([])
		for y in range(height):
			board_array[x].append(0)
	
	

func get_board_value():
	var index = 0
	var value = 0
	for y in range(width):
		for x in range(height):
			value += (pow(3,index)*board_array[x][y])
			index += 1
	return value
	
			
			