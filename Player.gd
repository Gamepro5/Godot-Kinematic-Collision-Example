extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
var velocity = Vector3(0,0,0);
var direction = Vector3(0,0,0);
var speed = 5;
var gravity = 30;
var max_floor_angle = 45; #89 and move right lmao
var mouse_axis = Vector2(0,0);
var move_axis = Vector3(0,0,0);
var mouse_sensitivity = 12.0;
var head;


# Called when the node enters the scene tree for the first time.
func _ready():
	head = get_node("Head")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	camera_rotation()
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	
	
	velocity.x = direction.x * speed #we don't want to set the y velocity to zero!
	velocity.z = direction.z * speed
	var col = move_and_collide(velocity * delta, true, true, true)
	if (col):
		if (Vector3.UP.angle_to(col.get_normal()) < deg2rad(max_floor_angle)):
			velocity.y = speed * tan(Vector3.UP.angle_to(col.get_normal())-0.28) #-0.28 #0.28 is a buffer. It prevents tangent of 90 degrees, which is infinity, and it ensures the collision detection is going off.
			print(Vector3.UP.angle_to(col.get_normal())-0.28)
		else: #TODO: check if going down the slope, to set the velocity.y calculations to either negative or positive.
			velocity.y -= gravity * delta
			print("null")
	else:
		velocity.y -= gravity * delta
	move_and_collide(velocity * delta)
		
	#print(velocity)

	
	pass

#mouse stuff imported from another project
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_axis = event.relative

	if (event.is_action_pressed("UNFOCUS")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif (event.is_action_pressed("FOCUS")):	
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var horizontal: float = -mouse_axis.x * (mouse_sensitivity / 100)
		var vertical: float = -mouse_axis.y * (mouse_sensitivity / 100)
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot

