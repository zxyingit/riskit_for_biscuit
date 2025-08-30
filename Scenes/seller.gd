extends Node2D
class_name Seller
@export var cargo := preload("res://Scenes/cargo.tscn")
var cargo_node : Cargo
#@onready var cargo: Cargo = $Cargo
var ship_node:Node
func _ready() -> void:
	#var tween = create_tween()
	#tween.tween_property(self,"position",Vector2(0,0),10)
	#initiate()
	pass
	#TODO 偶尔货物会不见
func initiate():
	cargo_node = cargo.instantiate()
	cargo_node.stockroom = GlobalNode.stock_room
	cargo_node.onsale = true
	cargo_node.gravity_scale = 0
	add_child(cargo_node)
	pass
