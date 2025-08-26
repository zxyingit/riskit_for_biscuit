#A stone that will simply fall into the water
extends CharacterBody2D
class_name Stone
#the gravity value
var gravity = 10

#so the stone won't accelerate forever
var max_speed = 200

var max_speed_in_water = 100

func _physics_process(delta):
	#at each frame add gravity to our motion vector
	#clamp the motion value to the speed
	#move the stone with move_and_slide
	velocity.y += gravity
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	move_and_slide()

#initializes the stone at a set position
func initialize(pos):
	global_position = pos

func in_water():
	gravity = gravity / 3
	max_speed = max_speed_in_water
