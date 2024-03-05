extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -900.0
const FLY_VELOCITY = -300

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gun_flipped = false
var enable_rotation = false;

func _input(event):
	# Follow mouse rotation when mouse left button is clicked and disable when again mouse left 
	# button is clicked.
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		enable_rotation = !enable_rotation
			
	if enable_rotation and event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		# Calculate the direction vector from the character to the mouse
		var direction = mouse_position - global_position
		# Calculate the angle in radians
		var angle = atan2(direction.y, direction.x)
		# Rotate the character towards the mouse
		$character_container.rotation = angle

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		#
	if Input.is_action_pressed("ui_up"):
		velocity.y = FLY_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
			
	if direction:
		if not gun_flipped and direction == -1:
			gun_flipped = true
			
			$character_container.scale.x = -1
			if not enable_rotation:
				$character_container.rotation = -0.7
			
		elif gun_flipped and direction == 1:
			gun_flipped = false
			$character_container.scale.x = 1
			
			if not enable_rotation:
				$character_container.rotation = 0.3
				
		else:
			velocity.x = direction * SPEED
	else:
		if not enable_rotation:
			$character_container.rotation = 0.0
			
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


var flipped = false



func _on_main_gui_input(event):
	pass # Replace with function body.
