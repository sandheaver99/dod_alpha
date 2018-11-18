extends TouchScreenButton

var radius = 0
var x_offset = get_pos().x
var offset_vector = Vector2(0,0)
var playable = true
onready var tween = get_node("Tween")
var property = "transform/pos"
var speed = 150
var board_index
var old_board_index
var type
var type_progress_array = [-(global.width+1), 1] # allows bottom tiles to move -4 and left tiles to move + 1
var move_over = false

func _ready():
	
	set_process(true)

func _process(delta):
	if(is_pressed() and playable):
		move_over = false
		set_pos(get_global_mouse_pos()-Vector2(radius,radius)-offset_vector)
		#print(get_global_pos())
		
func set_offset(offset):
	offset_vector = offset
	
func set_playable(boolean):
	playable = boolean

func set_board_index(index):
	board_index = index

func set_type(number):
	type = number

func _on_TouchScreenButton_released():
	if(playable):
		move_to_nearest_square()
		update_global_board_array()
		update_counter_playability()
		

func move_to_nearest_square():
	old_board_index = board_index
	
	var nearest_distance = 99999
	var current_distance = 0
	var nearest_square = get_global_pos()-Vector2(0,80) # Vector2
	for square in global.squares_for_counters[type-1]:
		current_distance = get_global_pos().distance_squared_to(square)
		if(current_distance < nearest_distance):
			nearest_distance = current_distance
			nearest_square = square
	
	#set_pos(nearest_square-Vector2(radius,radius)-offset_vector)
	var new_board_index = global.squares_for_counters[type-1].find(nearest_square) + ((type % 2)* int(global.squares_for_counters[type-1].find(nearest_square)/global.width)) + ((type -1)*4)
	#print(new_board_index)
	#Is square a legal move?
	var is_square_free_legal = true
	if(((abs(new_board_index - board_index) == pow(4,type-1) ) and board_index < (global.width+1)*(global.height+1)) or (new_board_index - board_index) == type_progress_array[type-1]):
		# Legal but is it free?		
		var counters = get_tree().get_nodes_in_group('counter_group')
		for counter in counters:
			if(counter.board_index == new_board_index):
				is_square_free_legal = false
	else:
		is_square_free_legal = false
	
	if(is_square_free_legal):
		
		board_index = new_board_index
		move_over = true
		tween_to(get_global_pos()-Vector2(radius,radius)-offset_vector,nearest_square-Vector2(radius,radius)-offset_vector)
	else:
		var translated_board_index = [0,0]
		translated_board_index[0] = board_index - int(board_index/(global.width+1))
		translated_board_index[1] = board_index - (global.width+1)
		tween_to(get_global_pos()-Vector2(radius,radius)-offset_vector, global.squares_for_counters[type-1][translated_board_index[type-1]]-Vector2(radius,radius)-offset_vector)
		#print(translated_board_index)
	print(board_index)
	
	
func tween_to(start, end):
	var distance = start.distance_to(end)
	var time = distance / speed

	if tween.is_active():
		tween.stop(self, property)
	tween.interpolate_property(self, property, start, end, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#tween.interpolate_property(self, "transform/scale", Vector2(0,0), Vector2(1,1), .8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func update_global_board_array():
	if(board_index > (global.width+1) # not off the top of the board 
	and board_index < (global.width+1)*(global.height+1) # not off the bottom of the board
	and (board_index % (global.width+1) < global.width)): # not off the right of the board
		var x = board_index % (global.width+1)
		var y = int(board_index / (global.width+1)) - 1
		global.board_array[x][y] = type # playable + 1 eg: 1 (not playable) or 2 (playable)
		
	if((board_index != old_board_index) and old_board_index < (global.width+1)*(global.height+1)):
		var x = old_board_index % (global.width+1)
		var y = int(old_board_index / (global.width+1)) - 1
		global.board_array[x][y] = 0
		
	print(global.board_array)
	print(global.get_board_value())

func update_counter_playability():
	if(move_over):
		for counter in get_tree().get_nodes_in_group('counter_group'):
			counter.set_playable(!counter.playable)