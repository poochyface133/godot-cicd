extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

# readying a bunch of variables
@onready var enemyAnimation = $AnimatedSprite2D
var rng = RandomNumberGenerator.new()
var direction = 1
var player_alive = true

# changes the direction the minotaur moves. or makes him stand still.
func change_movement():
	var dir = rng.randi_range(-1,1)
	return dir

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# all of this will only happen while the player is alive
	if player_alive == true:
		# so it doesn't loop over itself.
		if enemyAnimation.get_animation() != "default":
			enemyAnimation.play("default")
			
		# randomness variable for whether or not it does stuff
		var do_stuff = rng.randi_range(1,50)
	
		# will change direciton if do_stuff is 25
		if do_stuff == 25:
			direction = change_movement()
			
		# will change direciton if it hits a wall
		if is_on_wall():
			direction = change_movement()
	
		if direction:
		# animation l/r facing control. direction < 0 is left, direction > 0 is right.
		# not included in the animation function for finer control.
			if direction < 0:
				enemyAnimation.flip_h = true
			elif direction > 0:
				enemyAnimation.flip_h = false
			
		# schmovement
		velocity.x = direction * SPEED
		move_and_slide()

		# Handle jump.
		if do_stuff == 10 and is_on_floor():
			velocity.y = JUMP_VELOCITY

# player's only got one hit so if they get hit its over and this animation only has to run once.
func _on_area_2d_body_entered(body: Node2D) -> void:
	player_alive = false
	enemyAnimation.play("attack")
	
