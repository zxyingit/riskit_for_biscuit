extends RigidBody2D
class_name Ship
#TODO 修改精灵图
@export_group("Wave Settings")
@export var wave_height: float = 50.0          # 波浪高度
@export var wave_frequency: float = 2        # 波浪频率
@export var wave_speed: float = 1.0            # 波浪速度
@export var max_torque: float = 100.0          # 最大扭矩
@export var weight := 0.0
#@export var value := 0.0
@export var money := 100
var sink := false
var time: float = 0.0
var initial_position: Vector2

func _ready():
	sell_all()
	GlobalNode.ship_node = self
	initial_position = global_position
	# 设置物理属性
	mass = 2.0
	#gravity_scale = 0.3  # 减小重力模拟浮力

func _process(delta: float) -> void:
	if sink:
		weight+=delta

func _physics_process(delta):
	time += delta

	## 模拟波浪运动
	simulate_wave_motion(delta)
	
	# 应用随波浪的扭矩
	apply_wave_torque()
	pass

func simulate_wave_motion(delta):
	 #水平方向的波浪漂移
	var horizontal_offset = cos(time * wave_frequency) * wave_height * 0.2/10
	
	# 垂直方向的波浪起伏
	var vertical_offset = cos(time * wave_frequency) * wave_height/10
	
	# 应用位置偏移（通过力而不是直接设置位置）
	var target_position = initial_position + Vector2(horizontal_offset, vertical_offset)
	var tmp = global_position
	var direction = (target_position - global_position).normalized()
	var force_strength = 5.0
	var gravity = weight/2#重力
	var buoyancy = (position.y+10)*2#浮力
	var g_b_force = clamp(buoyancy-gravity,-100,100) *Vector2(0,-1)
	apply_central_force(direction * force_strength+g_b_force)
	pass
	
func apply_wave_torque():
	# 根据波浪相位应用扭矩
	var wave_phase = cos(time * wave_frequency)
	var torque = wave_phase * max_torque
	var sign = true if cos(time * wave_frequency*2)>0 else false#正负符号，使船左右摆动
	if !sign:
		torque = -torque
	apply_torque(torque)
	pass
	
# 可选：添加一些随机性
#func add_random_sway():
	#var random_torque = randf_range(-20.0, 20.0)
	#apply_torque(random_torque)


func _on_ship_sink(area: Area2D) -> void:#没入水中
	if area.is_in_group("watersurface"):
		print("sink")
		sink = true
		GlobalNode.stock_room.sink =true

		
	pass # Replace with function body.


func _on_ship_not_sink(area: Area2D) -> void:
	if area.is_in_group("watersurface"):
		print("not sink")
		sink = false
		GlobalNode.stock_room.sink =false

	pass # Replace with function body.

func sell_all():#卖掉所有货物
	var cargos = GlobalNode.stock_room.get_cargos()
	var time_interval = 2
	for cargo in cargos:
		await get_tree().create_timer(time_interval).timeout
		time_interval = clamp(time_interval/2,0.3,2)
		cargo.selled()
		pass
	pass
