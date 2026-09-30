extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

@onready var playerAnimation = $AnimatedSprite2D
@onready var playerHurtbox = $AnimationPlayer

@onready var alive = true

#playing the animations with the proper hitboxes depending on left or right facing
func play_animation(anim, lr) -> void:
	# lr > 0 is right, lr < 0 is left
	if lr > 0:
		playerAnimation.play(anim)
		playerHurtbox.play(anim)
	else:
		# default has no l/r difference in hitbox, so that will just stay the same.
		if anim == "default":
			playerHurtbox.play(anim)
		else:
			# anything besides default will play the left animations.
			var animL = "".join(PackedStringArray([anim, "L"]))
			playerHurtbox.play(animL)
		playerAnimation.play(anim)	

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right") # Get the input direction and handle the movement.
	var exit = Input.is_action_just_pressed("to_menu") # whether or not esc has been pressed
	
	if exit:
			get_tree().change_scene_to_file("res://menu.tscn")
			
	if alive == true:
			
		# when pressing left or right
		if direction:
		# animation l/r facing control. direction < 0 is left, direction > 0 is right.
		# not included in the animation function for finer control.
			if direction < 0:
				playerAnimation.flip_h = true
			else:
				playerAnimation.flip_h = false
			
		# animation control. stops it from playing over itself and other animations besides idle.
			if (playerAnimation.get_animation() == "default"):
				play_animation("run", direction)
	
		# moves the direction.
			velocity.x = direction * SPEED
			move_and_slide()
		
	# when not pressing left or right
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if playerAnimation.get_animation() == "run":
				play_animation("default", direction)
			move_and_slide()

	# jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# gravity and animation control
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			# idle will play only when you're on the ground and not running.
			if playerAnimation.get_animation() != "run":
				play_animation("default", direction)

# will stop input reception and play the death animation
func _on_area_2d_body_entered(body: Node2D) -> void:
	alive = false
	playerAnimation.play("die")
	
