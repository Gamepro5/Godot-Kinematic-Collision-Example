extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
var velocity = Vector3(0,0,0);
var direction = Vector3(0,0,-1)
var speed = 2.5;
var gravity = 30;
var max_floor_angle = 55; #89 and move right lmao



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	velocity.x = direction.x * speed #we don't want to set the y velocity to zero!
	velocity.z = direction.z * speed
	var col = move_and_collide(velocity * delta, true, true, true)
	if (col):
		if (Vector3.UP.angle_to(col.get_normal()) < deg2rad(max_floor_angle)):
			velocity.y = speed * tan(Vector3.UP.angle_to(col.get_normal())-0.28) #-0.28 #0.28 is a buffer. It prevents tangent of 90 degrees, which is infinity, and it ensures the collision detection is going off.
		else: #TODO: check if going down the slope, to set the velocity.y calculations to either negative or positive.
			velocity.y -= gravity * delta
	else:
		velocity.y -= gravity * delta
	velocity = move_and_slide(velocity)
		
	print(velocity)

	
	pass
