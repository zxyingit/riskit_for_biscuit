extends Node
@export var continue_create := true
@export var ship : Node
var seller = preload("res://Scenes/seller.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_seller()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_seller():
	var seller_node :Seller = seller.instantiate()
	seller_node.global_position = Vector2(250,0)
	seller_node.z_index = 1
	seller_node.ship_node = ship
	seller_node.initiate()
	add_child(seller_node)
	var tween = create_tween()
	tween.tween_property(seller_node,"global_position",Vector2(-250,0),10)
	var timer = get_tree().create_timer(10.0)
	# 连接timeout信号
	timer.timeout.connect(_on_timer_timeout)
	
func _on_timer_timeout():
	create_seller()
	pass
