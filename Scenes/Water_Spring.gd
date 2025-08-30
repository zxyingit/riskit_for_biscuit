##### Spring Modelling

extends RigidBody2D
class_name WaterSpring
#the spring's current velocity
#var velocity: Vector2 = Vector2.ZERO

#the force being applied to the spring
var force := Vector2.ZERO

#the current height of the spring
var height = 0

#the natural position of the spring
var target_height = 0

var target_x_position

@onready var collision = $Area2D/CollisionShape2D
@export var horizon_canstant := 0.015
@export var horizon_dampening := 0.03
# the index of this spring
#we will set it on initialize
var index = 0

#how much an external object movement will affect this spring
var motion_factor = 0.015

#the last instance this spring collided with
#we check so it won't collide twice
var collided_with = null

#we will trigger this signal to call the splash function
#to makeve move our wa!
signal splash

func water_update(spring_constant, dampening):
	## This function applies the hooke's law force to the spring!!
	## This function will be called in each frame
	## hooke's law ---> F =  - K * x 
	
	#update the height value based on our current position
	height = position.y
	#
	##the spring current extension
	#var height_distance = height - target_height
	#var horizon_distance = position.x - target_x_position
	#var loss = -dampening * velocity.y
	#var horizon_loss = -horizon_dampening * velocity.x
	##hooke's law:
	#force = Vector2(-horizon_canstant*horizon_distance*5+horizon_loss,- spring_constant * height_distance + loss)
	#
	##apply the force to the velocity
	##equivalent to velocity = velocity + force
	#velocity += force
	##make the spring move!
	#velocity.x = clampf(velocity.x,-5.0,5.0)
	#velocity.y = clampf(velocity.y,-10.0,10.0)
	#position += velocity
	#position.x = clampf(position.x,target_x_position-10,target_x_position+10)
	#position.y = clampf(position.y,target_height-50,target_height+50)
	pass

func initialize(x_position,id):
	height = position.y
	target_height = position.y
	linear_velocity = Vector2.ZERO
	position.x = x_position
	target_x_position = x_position
	index = id

func set_collision_width(value):
	#this function will set the collision shape size of our springs
	
	var extents = (collision.shape as RectangleShape2D).size * 0.5
	
	#the new extents will mantain the value on the y width
	#the "value" variable is the space between springs, which we already have
	var new_extents = Vector2(value/2, extents.y)
	
	#set the new extents
	collision.shape.size = new_extents * 2.0
	pass


#func _on_Area2D_body_entered(body:RigidBody2D):
	##called when a body collides with a spring
	##if the body already collided with the spring, then do not collide
	##if body is not Stone:
		##return
	#if body == collided_with:
		#return
	#
	##the body is the last thing this spring collided with
	#collided_with = body
	#
	##we multiply the motion of the body by the motion factor
	##if we didn't the speed would be huge, depending on your game
	#var speed = body.linear_velocity.y * motion_factor
	#
	##emit the signal "splash" to call the splash function, at our water body script
	#emit_signal("splash",index,speed)
	#pass # Replace with function body.

func _integrate_forces(state):
	# 获取当前变换
	#var current_transform = state.transform
	## 强制X位置为固定值，保持Y位置不变
	#var result = current_transform.rotated(-current_transform.get_rotation())
	## 应用修改后的变换
	#state.transform = result
	PhysicsServer2D
	var height_distance = height - target_height
	var horizon_distance = position.x - target_x_position
	var loss = -0.03 * linear_velocity.y
	var horizon_loss = -horizon_dampening * linear_velocity.x
	#hooke's law:
	force = Vector2((-horizon_canstant*horizon_distance*5+horizon_loss)*500,(- 0.015 * height_distance + loss)*1000)
	#assert(position.y<50)
	apply_force(force)
