extends Node2D
class_name StockRoom
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_nodes: Node2D = $VisibleNodes
@onready var polygon_2d: Polygon2D = $Polygon2D

#@export var water_height := 0.0

@export var sink := false
#TODO 漏水粒子特效
func _ready() -> void:
	sprite_2d.modulate.a = 1
	GlobalNode.stock_room = self
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	queue_redraw()
	if sink:
		var points = polygon_2d.polygon
		if points[0].y > 0:
			points[0].y -= delta/3
			points[1].y -= delta/3
			polygon_2d.polygon = points

func _draw() -> void:
	var points = polygon_2d.polygon
	draw_polygon(points, PackedColorArray([polygon_2d.color]))

func _on_area_2d_mouse_entered() -> void:
	print("mouse enter")
	var tween = create_tween()
	tween.tween_property(sprite_2d,"modulate:a",0,0.5)
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	print("mouse exit")
	var tween = create_tween()
	tween.tween_property(sprite_2d,"modulate:a",1,0.5)
	await tween.finished

	pass # Replace with function body.

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Cargo:
		GlobalNode.ship_node.weight+=body.weight
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Cargo:
		GlobalNode.ship_node.weight-=body.weight
	pass # Replace with function body.

func get_cargos() -> Array[Node]:
	var result = find_children("*","Cargo") as Array[Cargo]
	return result
