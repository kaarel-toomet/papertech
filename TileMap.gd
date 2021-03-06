extends TileMap

export (PackedScene) var kuld

var waternoise = OpenSimplexNoise.new()#noises used by worldgen


export var chunkW = 15 #when changing these, change the numbers in hullmyts's script, that are used in the changechunk signal
export var chunkH = 10

var sed = 0

var wOffsetx = -1 # activewindow offset, top-left chunk in tiles
var wOffsety = -1

var timer = 0
var xo = 123



var mxy
var paused = false

"""
block adding checklist
1.add image to assets folder
2.add to tileset
3.add to breakto, solid and flammable lists if needed
4.add to lighting lists if needed
5.add to ID comments
6.add image and image load to HUD script
7.add to blocks dict in HUD script
8.add to list in hullmyts
9.add ingredient slot
"""

var ingredients = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0]

var breakto = {-1:-1, 0:0, 1:0, 2:0, 3:0, 4:0, 5:0,
	6:0, 7:0, 8:0, 9:0, 10:0, 11:0, 12:0, 13:0,
	14:0, 15:0, 16:0, 17:0, 18:0, 19:0, 20:0, 21:0,
	22:0, 23:0, 24:0, 25:0, 26:0, 27:0, 28:0, 29:0,
	30:0, 31:0, 32:0, 33:0, 34:0, 35:0, 36:0}
var solid = [2,3,4,5,6,7,8,10,12,16,17,18,
				19,20,21,22,23,25,26,27,28,29,30,31,34,35]
var flammable = [5,6,8,16,19,21,32,33,35,36]
#0:air, 1:water, 2:paper, 3:thick paper, 4:wet paper, 5:crafter, 6:broken paper
#7:pump, 8:extractor, 9:water buffer, 10:paperball, 11:paperball buffer, 12: ancient paperball
#13: ancient paperball buffer, 14:lava, 15:lava buffer, 16:ancient document, 17:gold
#18:monster ruins, 19:magic crystal, 20:up pipe, 21:right pipe, 22:down pipe, 23:left pipe
#24:fire, 25:magic spikes, 26:detector, 27:down detector, 

#28:pickaxe, 29:sword, 30:lamp
#31:????, 32:oil, 33:oil buffer, 34:bucket, 35:closed door, 36:open door
#



func generate(cx,cy):
	if $generated.get_cell(cx,cy) != -1:
		return
	$generated.set_cell(cx,cy,0)
	for x in range(chunkW*cx,chunkW*(cx+1)):
		for y in range(chunkH*cy,chunkH*(cy+1)):
			#if get_cell(x,y) != -1: continue
			var gencell = 2
			
			var wnoiseval = waternoise.get_noise_2d(x,y)
			if wnoiseval > 0.3:
				gencell = 1
			
			if get_cell(x,y) == -1:
				set_cell(x,y,gencell)
			



#			var noiseval = mainnoise.get_noise_2d(x+xo,y)
#			var noisevaladd = max(y,min(-y-99,y+101))
#			var anoisevaladd = max(y-1,min(-y-98,y+100))
#
#			noiseval *= (gnarlnoise.get_noise_1d(x+xo))*200
#			noiseval += continentnoise.get_noise_1d(x+xo)*40
#			noiseval += noisevaladd
#
#			var anoiseval = mainnoise.get_noise_2d(x+xo,y-1)
#
#			anoiseval *= (gnarlnoise.get_noise_1d(x+xo))*200
#			anoiseval += continentnoise.get_noise_1d(x+xo)*40
#			anoiseval += anoisevaladd
#
#			if noiseval > 0: # stone/grass/sand/...
#				gencell = 4 # stone
#				if y < -50 and rand_range(0,1) < 0.02: gencell = 13 # bauxite
#				if lavanoise.get_noise_2d(x+xo,y) > 0.4 - 0.0005*(cy*chunkH): gencell = 14 # large lava
#				if anoiseval < 0:
#					gencell = 2 # grass
#					#if true:#rand_range(0,1) < 0.1:
#						#gencell = 5
#						#for j in range(y-randi()%10-2,y-1):
#							#set_cell(x,y,5)
#					if y >= -1:
#						gencell = 3 # sand
#				if abs(cavenoise.get_noise_2d(x+xo,y)) < cavethicnoise.get_noise_2d(x+xo,y)*0.2+0.05:
#					gencell = 0 # caves
#			elif noiseval < 0: # air/water
#				gencell = 0
#				if y >= 0:
#					gencell = 1
#				#if get_cell(x,y+1) == 2:# and rand_range(0,1) < 0.1:
#					#gencell= 5
#
#
#			if get_cell(x,y) == -1:
#				set_cell(x,y,gencell)
#	for x in range(chunkW*cx,chunkW*(cx+1)):
#		if rand_range(-0.1,1) < treenoise.get_noise_1d(x+xo):
#			for y in range(chunkH*cy,chunkH*(cy+1)):
#				if get_cell(x,y) == 2:
#					var top = (y-randi()%6)-5
#					for j in range(top-5,y):
#						for i in range(x-5,x+5):
#							var dist = Vector2(abs(x-i),abs(j-(top)))
#							if dist[0]+dist[1] < 3+rand_range(-0.5,1.5) and j < top+1:
#								set_cell(i,j,6)
#						if j >= top: set_cell(x,j,5)
#		for y in range(chunkH*cy,chunkH*(cy+1)):
#			if rand_range(0,1) < 0.1 and get_cell(x,y+1) == 4 and get_cell(x,y) == 0:
#				set_cell(x,y,7)
#			if rand_range(0,1) < 0.1 and get_cell(x,y+1) == 3 and get_cell(x,y) == 1:
#				set_cell(x,y,20)
#
#
#		if rand_range(0,1) < 0.01:
#			for y in range(chunkH*cy,chunkH*(cy+1)):
#				if get_cell(x,y) == 2:
#					for i in range(x,x+5):
#						for j in range(y-5,y):
#							set_cell(i,j,19)
#					for i in range(x+1,x+4):
#						for j in range(y-4,y-1):
#							set_cell(i,j,0)
#					set_cell(x,y-2,0)
#					if y > -50:
#						set_cell(x+3,y-2,7)
#					else:
#						set_cell(x+3,y-2,21)
#		for y in range(chunkH*cy,chunkH*(cy+1)): # sand
#			if get_cell(x,y) == 4 and rand_range(0,1) < 0.005:
#				for i in range(x-4,x+4):
#					for j in range(y-4,y+4):
#						var dist = abs(x-i) + abs(y-j)
#						if dist < rand_range(1.5,3.5):
#							set_cell(i,j,3)
#		for y in range(chunkH*cy,chunkH*(cy+1)): # clay
#			if get_cell(x,y) == 4 and rand_range(0,1) < 0.005:
#				for i in range(x-4,x+4):
#					for j in range(y-4,y+4):
#						var dist = abs(x-i) + abs(y-j)
#						if dist < rand_range(1.5,3.5):
#							set_cell(i,j,25)
#		if chunkH*cy < -50:
#			for y in range(chunkH*cy,chunkH*(cy+1)): # small lava
#				if get_cell(x,y) == 4 and rand_range(0,1) < 0.0025:
#					for i in range(x-4,x+4):
#						for j in range(y-4,y+4):
#							var dist = abs(x-i) + abs(y-j)
#							if dist < rand_range(1.5,3.5) and get_cell(i,j) == 4:
#								set_cell(i,j,14)
#		for y in range(chunkH*cy,chunkH*(cy+1)): # oil
#			if get_cell(x,y) == 4 and rand_range(0,1) < 0.01*(oilnoise.get_noise_2d(x+xo,y))-0.001:
#				for i in range(x-10,x+10):
#					for j in range(y-10,y+10):
#						var dist = abs(x-i) + abs(y-j)
#						if dist < rand_range(7,13):
#							set_cell(i,j,32)
#		for y in range(chunkH*cy,chunkH*(cy+1)): # water
#			if get_cell(x,y) == 4 and rand_range(0,1) < 0.002:
#				for i in range(x-4,x+4):
#					for j in range(y-4,y+4):
#						var dist = abs(x-i) + abs(y-j)
#						if dist < rand_range(1.5,3.5):
#							set_cell(i,j,1)
#		for y in range(chunkH*cy,chunkH*(cy+1)): # ????
#			if rand_range(0,1) < 0.0000001*y and y > 100:
#				for i in range(x,x+14):
#					for j in range(y,y+15):
#						set_cell(i,j,0)
#				set_cell(x,y,31)
							
				
			#if randi() % 1000 == 0:
				#var spawn = kuld.instance()
				#get_parent().get_node("kullad").add_child(spawn)
				#spawn.position = Vector2(x*32,y*32)
				#spawn.scale = Vector2(2,2)
				
func lammutus(pos):
	var hud = get_parent().get_node("hud")
	pos.x = floor(pos.x)
	pos.y = floor(pos.y)
	if !hud.inventory.has(get_cellv(pos)) and !hud.empty < 20: return
	hud.collect(get_cellv(pos))
	#if not get_cell(x,y) in solid:
	#	return
	set_cellv(pos,breakto[get_cellv(pos)])
	if randi() % 100 == 0:
		var spawn = kuld.instance()
		get_parent().get_node("kullad").add_child(spawn)
		spawn.position = Vector2(pos.x*32+16,pos.y*32+16)
		spawn.scale = Vector2(2,2)

func ehitus(pos):
	var hud = get_parent().get_node("hud")
	if hud.amounts[hud.select] == 0: return
	pos.x = floor(pos.x)
	pos.y = floor(pos.y)
	if !hud.inventory[hud.select] in solid and get_cellv(pos) in [1,14,32]: return
		
	if get_cellv(pos) in solid: return
	#print("acese 2")
	set_cellv(pos,hud.inventory[hud.select])
	hud.amounts[hud.select] -= 1

#func save_chunk(cx,cy): ##cx and cy are in chunks
	#var chunks := File.new()
	#chunks.open("res://world/chunks.gwrld",File.WRITE)
	#chunks.store_double(cx)
	#chunks.store_double(cy)
	#for chunk in $generated.get_used_cells():
		#if chunk.x == cx and chunk.y == cy:
			#for x in range(chunkW):
				#for y in range(chunkH):
					#chunks.store_8(get_cell(x+cx*chunkW, y+cy*chunkH))
	#chunks.close

func save_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.WRITE)
	for chunk in $generated.get_used_cells():
		chunks.store_double(chunk.x)
		chunks.store_double(chunk.y)
		for x in range(chunkW):
			for y in range(chunkH):
				chunks.store_8(get_cell(x+chunk.x*chunkW, y+chunk.y*chunkH))
	chunks.close()
	var data := File.new()
	data.open("res://world/data.gwrld",File.WRITE)
	data.store_8(get_parent().get_node("hullmyts").health)
	data.store_8(get_parent().get_node("hud").kuld)
	data.store_8(get_parent().get_node("hud").kolliv)
	for s in range(20):
		data.store_8(get_parent().get_node("hud").inventory[s])
		data.store_16(get_parent().get_node("hud").amounts[s])
	data.store_double(sed)
	data.store_double(get_parent().get_node("hullmyts").spawnpoint.x)
	data.store_double(get_parent().get_node("hullmyts").spawnpoint.y)
	data.store_64(int(get_parent().get_node("hud").itime))
	#data.store_double(get_parent().get_node("hullmyts").position[0])
	#data.store_double(get_parent().get_node("hullmyts").position[1])
	data.close()
	
#func load_chunk(cx,cy): ##cx and cy are in chunks
#	var chunks := File.new()
	#chunks.open("res://world/chunks.gwrld",File.READ)
	
	#if chunks.file_exists("res://world/chunks.gwrld"):
		#while chunks.get_position() != chunks.get_len():
			##var chunk := Vector2()
			#chunk.x = chunks.get_double()
			#chunk.y = chunks.get_double()
			#$generated.set_cellv(chunk,0)
			#for x in range(chunkW):
				#for y in range(chunkH):
					#set_cell(x+chunk.x*chunkW,y+chunk.y*chunkH,chunks.get_8())
	#chunks.close
	
func load_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.READ)
	
	if chunks.file_exists("res://world/chunks.gwrld"):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_double()
			chunk.y = chunks.get_double()
			$generated.set_cellv(chunk,0)
			for x in range(chunkW):
				for y in range(chunkH):
					set_cell(x+chunk.x*chunkW,y+chunk.y*chunkH,chunks.get_8())
		chunks.close()
		
	else:
		print("chunks file not found")
		
	var data := File.new()
	data.open("res://world/data.gwrld",File.READ)
	if data.file_exists("res://world/data.gwrld"):
		get_parent().get_node("hullmyts").health = data.get_8()
		get_parent().get_node("hud").kuld = data.get_8()
		get_parent().get_node("hud").kolliv = data.get_8()
		for s in range(20):
			get_parent().get_node("hud").inventory[s] = data.get_8()
			get_parent().get_node("hud").amounts[s] = data.get_16()
		sed = data.get_double()
		get_parent().get_node("hullmyts").spawnpoint.x = data.get_double()
		get_parent().get_node("hullmyts").spawnpoint.y = data.get_double()
		get_parent().get_node("hud").itime = data.get_64()
	else:
		print("data file not found")
	data.close()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	sed = randi()
	set_cell(0,0,0)
	load_world()############################################Rtrrrrre
	seed(sed)
	
#	gnarlnoise.seed = sed+434
#	gnarlnoise.octaves = 5
#	gnarlnoise.period = 300
#	gnarlnoise.persistence = 0.5
#	gnarlnoise.lacunarity = 2
#
#	continentnoise.seed = sed+222
#	continentnoise.octaves = 5
#	continentnoise.period = 400
#	continentnoise.persistence = 0.5
#	continentnoise.lacunarity = 2

	waternoise.seed = sed+32
	waternoise.octaves = 7
	waternoise.period = 20
	waternoise.persistence = 0.5
	waternoise.lacunarity = 2
#
#	cavenoise.seed = sed+39
#	cavenoise.octaves = 7
#	cavenoise.period = 100
#	cavenoise.persistence = 0.5
#	cavenoise.lacunarity = 2
#
#	cavethicnoise.seed = sed+123
#	cavethicnoise.octaves = 7
#	cavethicnoise.period = 100
#	cavethicnoise.persistence = 0.75
#	cavethicnoise.lacunarity = 2
#
#	treenoise.seed = sed+321
#	treenoise.octaves = 5
#	treenoise.period = 400
#	treenoise.persistence = 0.5
#	treenoise.lacunarity = 2
#
#	oilnoise.seed = sed+131
#	oilnoise.octaves = 5
#	oilnoise.period = 300
#	oilnoise.persistence = 0.5
#	oilnoise.lacunarity = 2
	
	scroll(0,0)
	fix_invalid_tiles()
	
func scroll(sx,sy): # sx and sy in chunks
	#for cx in range(3):
		#for cy in range(3):
			#for x in range(chunkW*(cx+wOffsetx),chunkW*(cx+wOffsetx+1)):
				#for y in range(chunkH*(cy+wOffsety),chunkH*(cy+wOffsety+1)):
					#pass#set_cell(x,y,-1)
					#fix_invalid_tiles()
	for cx in range(3):
		for cy in range(3):
			generate(cx + wOffsetx + sx, cy + wOffsety + sy)
	wOffsetx += sx
	wOffsety += sy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_parent().paused:
		return
	timer += delta
	var parent = get_parent()
	mxy = parent.get_global_mouse_position()/32
	var hxy = parent.get_node("hullmyts").position
	var hud = parent.get_node("hud")
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(hxy+Vector2(16,16), mxy*32-(mxy*32-hxy).normalized()*30, [parent.get_node("hullmyts")])
	#if Input.is_action_just_pressed("LCLICK") and (not result):
		#emit_signal("lammutus",get_cell(floor(mxy[0]),floor(mxy[1])))
	if Input.is_action_just_pressed("RCLICK"):# and (not result):
		ehitus(mxy)
	if Input.is_action_just_pressed("LCLICK"):
		if get_cell(floor(mxy.x),floor(mxy.y)) in [1,14,32] and hud.inventory[hud.select] == 34:
			lammutus(mxy)
		elif get_cell(floor(mxy.x),floor(mxy.y)) == 35:
			set_cell(floor(mxy.x),floor(mxy.y),36)
		elif get_cell(floor(mxy.x),floor(mxy.y)) == 36:
			set_cell(floor(mxy.x),floor(mxy.y),35)
	
	if timer >= 0.5: ## Update blocks
		timer = 0
		for x in range(wOffsetx*chunkW - chunkW*2,wOffsetx*chunkW+chunkW*5):
			for y in range(wOffsety*chunkH - chunkH*3,wOffsety*chunkH+chunkH*6):
				$light.update_tile(x,y)
				if get_cell(x,y) == 5: #Crafter
					for i in range(len(ingredients)): ingredients[i] = 0
					ingredients[get_cell(x+1,y)] += 1
					ingredients[get_cell(x-1,y)] += 1
					ingredients[get_cell(x,y+1)] += 1
					ingredients[get_cell(x,y-1)] += 1
					
					if ingredients[3] == 4: # extract water
						set_cell(x+1,y,6)
						set_cell(x-1,y,6)
						set_cell(x,y+1,1)
						set_cell(x,y-1,6)
						
					if ingredients[4] == 3 and ingredients[0] == 1: # extract water
						set_cell(x+1,y,2)
						set_cell(x-1,y,2)
						set_cell(x,y+1,2)
						set_cell(x,y-1,1)
						
					if ingredients[6] == 2 and ingredients[3] == 2: # pump
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,7)
						set_cell(x,y-1,7)
					
					if ingredients[7] == 1 and ingredients[4] == 3: # extractor
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,8)
						set_cell(x,y-1,0)
						
					if ingredients[10] == 2 and ingredients[0] == 2: # paper
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,2)
						set_cell(x,y-1,0)
					
					if ingredients[2] == 4: # thick paper
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,3)
						set_cell(x,y-1,0)
						
					if ingredients[12] == 4: # ancient document
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,16)
						set_cell(x,y-1,0)
				
				if get_cell(x,y) == 7: #Pump
					var j = y-1
					if get_cell(x,y+1) in [1]:
						while true:
							if get_cell(x,j) == 7:
								j -= 1
							elif get_cell(x,j) == 0:
								set_cell(x,j,get_cell(x,y+1))
								set_cell(x,y+1,0)
								break
							else:
								break
								
				if get_cell(x,y) == 8: # Extractor
					if get_cell(x,y-1) == 1 and get_cell(x,y+1) in [0,3]:
						set_cell(x,y-1,0)
						if get_cell(x,y+1) == 0:
							if rand_range(0,1) < 0.3:
								set_cell(x,y+1,11)
							if rand_range(0,1) < 0.02:
								set_cell(x,y+1,13)
					
				if get_cell(x,y) == 10 and get_cell(x,y+1) in [-1,0]: # Paper ball
					set_cell(x,y,0)
					set_cell(x,y+1,11)
				if get_cell(x,y) == 12 and get_cell(x,y+1) in [-1,0,1]: # Ancient paper ball
					set_cell(x,y,get_cell(x,y+1))
					set_cell(x,y+1,13)
					
				if get_cell(x,y) == 16: # Ancient document
					for i in range(len(ingredients)): ingredients[i] = 0
					ingredients[get_cell(x+1,y)] += 1
					ingredients[get_cell(x-1,y)] += 1
					ingredients[get_cell(x,y+1)] += 1
					ingredients[get_cell(x,y-1)] += 1
					
					if ingredients[12] == 4: # magic crystal
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,19)
						set_cell(x,y-1,0)
					if ingredients[19] == 1 and ingredients[7] == 2 and ingredients[12] == 1: # up pipe
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,20)
						set_cell(x,y-1,0)
					if ingredients[19] == 1 and ingredients[3] == 2 and ingredients[6] == 1: # magic spikes
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,25)
						set_cell(x,y-1,0)
					if ingredients[19] == 1 and ingredients[3] == 2 and ingredients[20] == 1: # detector
						set_cell(x+1,y,0)
						set_cell(x-1,y,0)
						set_cell(x,y+1,26)
						set_cell(x,y-1,0)
						
				if get_cell(x,y) == 20:  # up pipe
					var i = x
					var j = y
					var p = 20
					var n = 0
					while true:
						n += 1
						if n > 100: return
						if get_cell(i,j) == 20 and p != 22:
							j -= 1
							p = 20
						elif get_cell(i,j) == 21 and p != 23:
							i += 1
							p = 21
						elif get_cell(i,j) == 22 and p != 20:
							j += 1
							p = 22
						elif get_cell(i,j) == 23 and p != 21:
							i -= 1
							p = 23
						elif get_cell(i,j) in [0,1]:
							var o = get_cell(i,j)
							set_cell(i,j,get_cell(x,y+1))
							set_cell(x,y+1,o)
							break
						else:
							break
#					var j = y-1
#					while true:
#						if get_cell(x,j) == 20:
#							j -= 1
#						elif get_cell(x,j) in [0,1]:
#							var o = get_cell(x,j)
#							set_cell(x,j,get_cell(x,y+1))
#							set_cell(x,y+1,o)
#							break
#						else:
#							break
				if get_cell(x,y) == 21:  # right pipe
					var i = x
					var j = y
					var p = 21
					var n = 0
					while true:
						n += 1
						if n > 100: return
						if get_cell(i,j) == 20 and p != 22:
							j -= 1
							p = 20
						elif get_cell(i,j) == 21 and p != 23:
							i += 1
							p = 21
						elif get_cell(i,j) == 22 and p != 20:
							j += 1
							p = 22
						elif get_cell(i,j) == 23 and p != 21:
							i -= 1
							p = 23
						elif get_cell(i,j) in [0,1]:
							var o = get_cell(i,j)
							set_cell(i,j,get_cell(x-1,y))
							set_cell(x-1,y,o)
							break
						else:
							break
				if get_cell(x,y) == 22:  # down pipe
					var i = x
					var j = y
					var p = 22
					var n = 0
					while true:
						n += 1
						if n > 100: return
						if get_cell(i,j) == 20 and p != 22:
							j -= 1
							p = 20
						elif get_cell(i,j) == 21 and p != 23:
							i += 1
							p = 21
						elif get_cell(i,j) == 22 and p != 20:
							j += 1
							p = 22
						elif get_cell(i,j) == 23 and p != 21:
							i -= 1
							p = 23
						elif get_cell(i,j) in [0,1]:
							var o = get_cell(i,j)
							set_cell(i,j,get_cell(x,y-1))
							set_cell(x,y-1,o)
							break
						else:
							break
				if get_cell(x,y) == 23:  # left pipe
					var i = x
					var j = y
					var p = 23
					var n = 0
					while true:
						n += 1
						if n > 100: return
						if get_cell(i,j) == 20 and p != 22:
							j -= 1
							p = 20
						elif get_cell(i,j) == 21 and p != 23:
							i += 1
							p = 21
						elif get_cell(i,j) == 22 and p != 20:
							j += 1
							p = 22
						elif get_cell(i,j) == 23 and p != 21:
							i -= 1
							p = 23
						elif get_cell(i,j) in [0,1]:
							var o = get_cell(i,j)
							set_cell(i,j,get_cell(x+1,y))
							set_cell(x+1,y,o)
							break
						else:
							break
							
				if get_cell(x,y) == 26: # Detector
					if get_cell(x,y-1) in [get_cell(x-1,y),get_cell(x+1,y)] and get_cell(x,y+1) == 0:
						set_cell(x,y+1,get_cell(x,y-1))
						set_cell(x,y-1,0)
						
				if get_cell(x,y) == 27: # Down facing detector
					if get_cell(x,y+1) in [get_cell(x-1,y),get_cell(x+1,y)] and get_cell(x,y-1) == 0:
						set_cell(x,y-1,get_cell(x,y+1))
						set_cell(x,y+1,0)
					
				if get_cell(x,y) == 25:  # Magic Spikes
					if get_cell(x,y-1) in [11,13]:
						get_parent().get_node("hud").collect(get_cell(x,y-1)-1)
						set_cell(x,y-1,0)
					if get_cell(x,y-1) in [10,12]:
						get_parent().get_node("hud").collect(get_cell(x,y-1))
						set_cell(x,y-1,0)
				
					
				if get_cell(x,y) == 1: # Water
					if get_cell(x+1,y) == 2: # wet paper
						set_cell(x+1,y,4)
					if get_cell(x-1,y) == 2:
						set_cell(x-1,y,4)
					if get_cell(x,y+1) == 2:
						set_cell(x,y+1,4)
					if get_cell(x,y-1) == 2:
						set_cell(x,y-1,4)
						
					if get_cell(x,y+1) == 0 and y+1 <= wOffsety*chunkH+chunkH*3:
						set_cell(x,y,0)
						set_cell(x,y+1,9)
					else:
						var l = get_cell(x-1,y) == 0
						var r = get_cell(x+1,y) == 0
						if x+1 > wOffsetx*chunkW+chunkW*3: r = false
						if x-1 < wOffsetx*chunkW: l = false
						if l and r:
							l = randi()%2 == 0
							r = !l
						if l:
							set_cell(x-1,y,9)
							if get_cell(x,y-1) != 1 and get_cell(x,y-1) != 9:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
						if r:
							set_cell(x+1,y,9)
							if get_cell(x,y-1) != 1 and get_cell(x,y-1) != 9:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
								
				if get_cell(x,y) == 32: # Oil
					if get_cell(x,y+1) == 0 and y+1 <= wOffsety*chunkH+chunkH*3:
						set_cell(x,y,0)
						set_cell(x,y+1,33)
					else:
						var l = get_cell(x-1,y) == 0
						var r = get_cell(x+1,y) == 0
						if x+1 > wOffsetx*chunkW+chunkW*3: r = false
						if x-1 < wOffsetx*chunkW: l = false
						if l and r:
							l = randi()%2 == 0
							r = !l
						if l:
							set_cell(x-1,y,33)
							if get_cell(x,y-1) != 1 and get_cell(x,y-1) != 33:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
						if r:
							set_cell(x+1,y,33)
							if get_cell(x,y-1) != 1 and get_cell(x,y-1) != 33:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
								
				if get_cell(x,y) == 14: # Lava
					for i in range(x-1, x+2):
						for j in range(y-1, y+2):
							if get_cell(i,j) == 23 and randi()%200 == 0:
								set_cell(i,j,30)
							if get_cell(i,j) == 1:
								set_cell(x,y,4)
					if get_cell(x,y+1) == 0 and y+1 <= wOffsety*chunkH+chunkH*3:
						set_cell(x,y,0)
						set_cell(x,y+1,15)
					else:
						var l = get_cell(x-1,y) == 0
						var r = get_cell(x+1,y) == 0
						if x+1 > wOffsetx*chunkW+chunkW*3: r = false
						if x-1 < wOffsetx*chunkW: l = false
						if l and r:
							l = randi()%2 == 0
							r = !l
						if l:
							set_cell(x-1,y,15)
							if get_cell(x,y-1) != 14 and get_cell(x,y-1) != 15:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
						if r:
							set_cell(x+1,y,15)
							if get_cell(x,y-1) != 14 and get_cell(x,y-1) != 15:
								set_cell(x,y,0)
							else:
								set_cell(x,y-1,0)
					for i in range(x-2,x+2): # lava setting fire
						for j in range(y-2,y+2):
							if get_cell(i,j) == 0 and randi()%10 == 0:
								set_cell(i,j,24)
				#if get_cell(x,y) == 14: # Waterfall
					#if get_cell(x,y+1) == 0:
						#set_cell(x,y+1,15)
					#elif get_cell(x,y+1) in solid:
						#set_cell(x,y,9)
					#elif get_cell(x,y+1) == 1:
						#if get_cell(x-1,y+1) != 0 and get_cell(x-1,y+1) != 14 and get_cell(x-1,y+1) != 0 and get_cell(x-1,y+1) != 14:
							#set_cell(x,y,9)
		for x in range(wOffsetx*chunkW,wOffsetx*chunkW+chunkW*3):
			for y in range(wOffsety*chunkH,wOffsety*chunkH+chunkH*3):
				if get_cell(x,y) == 9: # Water buffer
					set_cell(x,y,1)
				if get_cell(x,y) == 15: # Lava buffer
					set_cell(x,y,14)
				if get_cell(x,y) == 33: # Oil buffer
					set_cell(x,y,32)
				if get_cell(x,y) == 11: # Paperball buffer
					set_cell(x,y,10)
				if get_cell(x,y) == 13: # Ancient paperball buffer
					set_cell(x,y,12)
#				if get_cell(x,y) == 2 and get_cell(x,y-1) == 10 and rand_range(0,1) < 0.01 and $light.get_cell(x,y) > 5: # Seed growing
#					var top = (y-randi()%6)-5
#					for j in range(top-5,y):
#						for i in range(x-5,x+5):
#							var dist = Vector2(abs(x-i),abs(j-(top)))
#							if dist[0]+dist[1] < 3+rand_range(-0.5,1.5) and j < top+1:
#								set_cell(i,j,6)
#						if j >= top: set_cell(x,j,5)
				if get_cell(x,y) == 22 and (get_cell(x,y+1) == 6 or get_cell(x,y+1) == 5) and rand_range(0,1) < 0.01 and $light.get_cell(x,y) > 5: # Onion seed growing
					set_cell(x,y,21)
					set_cell(x,y-1,21)
#				if get_cell(x,y) == 24: # Fire
#					for i in range(x-1,x+2):
#						for j in range(y-1,y+2):
#							if get_cell(i,j) == 1 or get_cell(i,j) == 9:
#								set_cell(x,y,0)
#					if rand_range(0,1) < 0.05:
#						set_cell(x,y,0)
#					else:
#						for i in range(x-2,x+2):
#							for j in range(y-2,y+2):
#								if get_cell(i,j) in flammable and rand_range(0,1) < 0.1:
#									set_cell(i,j,24)
#								if get_cell(i,j) == 25 and rand_range(0,1) < 0.02:
#									set_cell(i,j,26)
#								if get_cell(i,j) == 3 and rand_range(0,1) < 0.02:
#									set_cell(i,j,27)
#								if get_cell(i,j) == 13 and rand_range(0,1) < 0.02:
#									set_cell(i,j,12)
				#$light.update_tile(x,y)

#func tarbreak(x,y):
#	if !solid.has(get_cell(x,y)): return
#	pcol = Vector2(x,y)
#	emit_signal("lammutus",get_cell(x,y))
					
func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		save_world()


func _on_hullmyts_changechunk(changex, changey):
	scroll(changex, changey)

