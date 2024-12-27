extends Node2D

@export var speed: float = 100  # Speed at which the cat moves
var direction: Vector2  # Direction the cat is moving in
var cat_sprite: Sprite2D  # Assuming the cat is a sprite

func _ready():
	# Initialize the cat sprite
	cat_sprite = $CatSprite  # Assuming you have a Sprite node as a child
	set_random_direction()  # Set an initial random direction
	print("Cat sprite is ready")

func _process(delta):
	# Move the cat based on the current direction and speed
	cat_sprite.position += direction * speed * delta
	
	# If the cat is about to leave the screen, change direction
	if cat_sprite.position.x < 0 or cat_sprite.position.x > get_viewport().size.x:
		set_random_direction()  # Change direction on X axis
	if cat_sprite.position.y < 0 or cat_sprite.position.y > get_viewport().size.y:
		set_random_direction()  # Change direction on Y axis

# Function to set a random direction for the cat
func set_random_direction():
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
