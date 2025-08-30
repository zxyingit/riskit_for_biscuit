extends CanvasLayer
@onready var barrel: Sprite2D = $barrel
@onready var flag: Sprite2D = $flag
var duration = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(barrel,"position",flag.position,duration)
	tween.finished.connect(on_tween_finished)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#texture_progress_bar.value +=1

	pass

func on_tween_finished():
	print("tween finished")
	EventBus.stage_timeup.emit()
	pass
