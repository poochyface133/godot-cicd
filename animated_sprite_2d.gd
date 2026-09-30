extends AnimatedSprite2D

@onready var crowAnim = self
@onready var hitbox = $crowcollectbox

var rng = RandomNumberGenerator.new()

# makes crow appear!
func appear():
	# more randomness
	var do_spawn = rng.randi_range(0,100)
	
	# crow will spawn in if do_spawn is 50
	if do_spawn == 50:
		hitbox.set_monitoring(true)
		crowAnim.set_position(Vector2(rng.randi_range(-200, 200),rng.randi_range(-200, 200)))
		crowAnim.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	crowAnim.play("default")
	# will only run the appear command if he's not there to prevent him from teleporting everywhere
	if crowAnim.is_visible() == false:
		hitbox.set_monitoring(false)
		appear()

# when he's collected he'll disappear
func _on_area_2d_body_entered(body: Node2D) -> void:
	crowAnim.set_visible(false)
