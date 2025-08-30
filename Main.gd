extends Node2D
#TODO 音乐
#TODOUI界面，教程提示，通关/失败UI
#TODO 多个关卡
#loads the stone scene
#var stone = preload("res://Scenes/Stone.tscn")
#var stone = preload("res://Scenes/ship.tscn")

var target = 10
#called when there's an input
func _input(event):
	if event.is_action_pressed("debug"):
		print("debug")

func _ready() -> void:
	EventBus.stage_timeup.connect(on_stage_timeup)
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Cargo:
		body.destroy()
	pass # Replace with function body.

func on_stage_timeup():
	if GlobalNode.ship_node.money >= target:
		EventBus.stage_clear.emit()
	else :
		EventBus.stage_fail.emit()
