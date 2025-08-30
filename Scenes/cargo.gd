extends RigidBody2D
class_name Cargo
var chosen := false
@export var infuence =1000
@export var stiffness = 100
@export var value := 100
@export var weight := 50
@export var cost := 60
@onready var sprite_2d: Sprite2D = $Sprite2D
@export var onsale:= false
@onready var ship : Ship = GlobalNode.ship_node
var stockroom:StockRoom
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf()>0.2:
		value = randi_range(10,200)
		weight = randi_range(10,100)
		cost = value* randf_range(0.5,0.9)
		scale*=weight/20
		if value/weight<0.5:
			sprite_2d.texture = load("res://Sprites/stone.png")
		elif value/weight<3.5:
			sprite_2d.texture = load("res://Sprites/silvblock.png")
		else:
			sprite_2d.texture = load("res://Sprites/goldblock.png")
	else:
		value = randi_range(10,200)
		weight = randi_range(10,100)
		cost = value* randf_range(0.5,0.9)
		scale*=2
		sprite_2d.texture = load("res://Sprites/mysterybox.png")
	pass # Replace with function body.
	ship = GlobalNode.ship_node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		if onsale:
			if buyed():
				onsale = false
				if stockroom:
					reparent(stockroom.visible_nodes,false)
					global_position = Vector2(0,-50)
					gravity_scale = 1.0
		else:
			chosen = true
		print("chosen")

	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_released("left_click"):
		print("not chosen")
		chosen = false

func _physics_process(delta: float) -> void:
	if chosen:
		var I = infuence
		var S = stiffness 
		var P = get_global_mouse_position() - global_transform.origin
		var M = mass
		var V = linear_velocity
		var impulse = (I*P)  - (S*M*V)
		apply_central_impulse(impulse * delta)
		#global_position = get_global_mouse_position()
	#position.x += 100*delta
	pass

func destroy():
	queue_free()

func selled():
	#TODO 音效
	#ship.weight-=weight
	#var ship : Ship = GlobalNode.ship_node
	if !ship:
		ship = GlobalNode.ship_node
	ship.money+=value
	destroy()

func buyed() -> bool:
	#var ship :Ship = GlobalNode.ship_node
	if ship.money>cost:
		ship.money-=cost
		#ship.weight+=weight
		ship.value+=value
		return true
	else:
		#TODO提示钱不够
		print("资金不够")
		return false
	pass
