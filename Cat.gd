extends CharacterBody2D  # Use CharacterBody2D for better collision handling

@export var money_per_second: int = 1  # How much money the cat earns every second
@export var speed: float = 150 # Speed at which the cat moves
var direction: Vector2  # Direction the cat is moving in
var cat_sprite: Sprite2D  # Assuming the cat is a sprite
var money: int = 0  # Track the money earned
#var money_timer: Timer

# Signal to notify when money is updated
#signal cat_money_updated(amount: int)
signal cat_ready()
signal cat_money_per_second(amount: int) 

func _ready():
	emit_signal("cat_ready")
	# Initialize the cat sprite
	cat_sprite = $CatSprite  
	# Set an initial random direction
	set_random_direction()
	
	emit_signal("cat_money_per_second", money_per_second)
	
	print("Cat node is ready")
	
	## Create and configure a timer
	#money_timer = Timer.new()
	#add_child(money_timer)  # Add the Timer as a child of the Cat node
	#print("Timer added to scene")
	#
	#money_timer.wait_time = 1.0  # Set to 1 second
	#money_timer.one_shot = false  # Repeats every second
	#money_timer.start()  # Start the timer
	#print("Timer started")
	#
	#money_timer.connect("timeout", Callable(self, "_on_money_timer_timeout"))  # Connect the timeout signal
	#print("Timer connected")
#
#func _on_money_timer_timeout():
	#print("Timer triggered!")  # Debugging to see if the function is called
	#money += money_per_second  # Add money per second
	#Global._on_money_updated(money)  # Notify other nodes of the money update

func _process(delta):
	# Move the cat using move_and_slide() for proper collision handling
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Flip the sprite depending on the movement direction
	if direction.x > 0:
		cat_sprite.scale.x = 1  # Facing right
	elif direction.x < 0:
		cat_sprite.scale.x = -1  # Facing left

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			print("Cat hit a wall, changing direction!")
			# Add a small random factor to the normal
			var random_factor = Vector2(randf_range(-1.5, 1.5), randf_range(-1.5, 1.5))
			direction = collision.get_normal() + random_factor


# Function to set a random direction for the cat
func set_random_direction():
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
