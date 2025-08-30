extends Node2D
@export_group("Wave Settings")
@export var wave_amplitude: float = 15.0        # 波浪幅度
@export var wave_length: float = 100.0          # 波浪长度
@export var wave_speed: float = 1.0             # 波浪速度
@export var resolution: int = 100               # 分辨率

@export_group("Appearance")
@export var wave_color: Color = Color.WHITE     # 波浪线颜色
@export var ocean_color: Color = Color.BLUE     # 海洋颜色
@export var line_thickness: float = 2.0         # 线宽

var time: float = 0.0
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	# 确保每帧重绘
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta):
	time += delta
	queue_redraw()  # 请求重绘

func _draw():
	# 生成波浪点
	var wave_points = generate_wave_points()
	
	# 绘制填充区域
	draw_ocean_fill(wave_points)
	
	# 绘制波浪线
	draw_polyline(wave_points, wave_color, line_thickness, true)

func generate_wave_points() -> PackedVector2Array:
	var points: PackedVector2Array = []
	var base_y = screen_size.y * 0.6  # 海平面基础位置
	
	for i in range(resolution + 1):
		var x = (i / float(resolution)) * screen_size.x
		var y = base_y + calculate_wave_value(x, time)
		points.append(Vector2(x, y))
	
	#TODO 调整波浪起伏和小船同步
	#var points: PackedVector2Array = []
	#var point_count = 200
	#
	#for i in range(point_count + 1):
		#var x = (i / float(point_count)) * length
		#var y = sin(x * frequency + phase) * amplitude
		#points.append(Vector2(x, y))
	
	return points

func calculate_wave_value(x: float, time_val: float) -> float:
	# 更复杂的波浪函数
	var main_wave = sin(x / wave_length + time_val * wave_speed) * wave_amplitude
	#var secondary_wave = cos(x / (wave_length * 0.7) + time_val * wave_speed * 0.8) * wave_amplitude * 0.6
	#var detail_wave = sin(x / (wave_length * 0.3) + time_val * wave_speed * 1.5) * wave_amplitude * 0.3
	return main_wave
	#return main_wave + secondary_wave + detail_wave

func draw_ocean_fill(wave_points: PackedVector2Array):
	# 创建填充多边形
	var fill_points = wave_points.duplicate()
	# 添加底部点
	fill_points.append(Vector2(screen_size.x, screen_size.y))
	fill_points.append(Vector2(0, screen_size.y))
	
	# 绘制填充多边形
	draw_polygon(fill_points, PackedColorArray([ocean_color]))

# 添加一些海洋细节
#func draw_ocean_details():
	## 绘制一些简单的海洋反光
	#var highlight_color = ocean_color.lightened(0.2)
	#for i in range(0, resolution, 10):
		#var x = (i / float(resolution)) * screen_size.x
		#var wave_y = calculate_wave_value(x, time) + screen_size.y * 0.6
		#draw_circle(Vector2(x, wave_y + 5), 2.0, highlight_color)
