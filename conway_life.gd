extends Spatial

#from random import randint, seed
#from time import time

# grid_size / height
# 50 / 100
# 20 / 15
var grid_size = [ 20, 20 ]
var tick_rate = 100
var camera_height = 15
var camera_step = 1

#screen = pygame.display.set_mode(size)
#pygame.display.set_caption("Conway's Game of Life")

var DEAD  = 0
var ALIVE = 1

var COLORS = [
    [0, 0, 0],
    [0, 150, 0]
]

var grid = []

onready var unit = preload('res://unit.tscn')
onready var camera = get_node('camera')

# will determine the cur and nxt
var cur = 0
var nxt = 1
var z = 0

var paused = false

var grid_seed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    camera.translation = Vector3(grid_size[0] / 2, camera_height, grid_size[0] / 2)
    
    seed(grid_seed)
    # initialize grid
    for x in range(grid_size[0]):
        grid.append([])
        for y in range(grid_size[1]):
            grid[x].append([ randi() % (ALIVE + 1), randi() % (ALIVE + 1) ])

func _fixed_process(delta):
    
    if Input.is_key_pressed(SPKEY):
        print('space')

onready var time_sum = 0.0

func _process(delta):
    time_sum += delta
    
    if not paused and time_sum > 60.0 / tick_rate:
        time_sum = 0.0
        
        # tick all cells
        for x in range(grid_size[0]):
            for y in range(grid_size[1]):
                
                var life = 0
                
                # find surrounding live cells
                for a in range(max(x - 1, 0), min(x + 2, grid_size[0])):
                    for b in range(max(y - 1, 0), min(y + 2, grid_size[1])):
                        if a == x and b == y:
                            continue
                        if grid[a][b][cur] == ALIVE:
                            life += 1
            
                # set next state
                if life < 2 or life > 3:
                    grid[x][z][nxt] = DEAD
            
                elif grid[x][z][cur] == ALIVE and (life == 2 or life == 3):
                    grid[x][z][nxt] = ALIVE
            
                elif grid[x][z][cur] == DEAD and life == 3:
                    grid[x][z][nxt] = ALIVE
            
                else:
                    grid[x][z][nxt] = grid[x][z][cur]
                
                # instance node
                if grid[x][z][nxt] == ALIVE:
                    var new_unit = unit.instance()
                    new_unit.translation = Vector3(x, z, y)
                    add_child(new_unit)
                
        z += 1
        var tmp = cur
        cur = nxt
        nxt = tmp
        
        camera.translate(Vector3(0, 0, camera_step))
