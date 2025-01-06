extends RigidBody2D

# Signals for the inventory
signal increase_quantity(item)
signal decrease_quantity(item)
signal entered_bowl
signal exited_bowl

var is_dragging : bool = true  # Initially set to true, will allow dragging immediately upon press
var fall_impulse = Vector2(0, 200)  # Example downward force, adjust as needed
var is_in_bowl : bool = false  # Track if the item is in the bowl
var is_left_mouse_pressed = false # Track if the item was clicked

# Define the screen bounds for deletion
var screen_bounds : Rect2
var bowl_area: Area2D
var bowl_walls: CollisionPolygon2D

func _ready():
	# Connect the bowl area
	bowl_area = get_tree().root.get_node("Kitchen").get_node("Bowl").get_node("BowlArea")
	bowl_area.connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	bowl_area.connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
	bowl_walls = get_tree().root.get_node("Kitchen").get_node("Bowl").get_node("BowlWalls")
	
	# Initialize screen bounds (adjust if needed for your resolution or camera)
	screen_bounds = Rect2(Vector2.ZERO, get_viewport().get_visible_rect().size)

	# Ensure this node can receive input events
	set_process_input(true)
	
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not is_left_mouse_pressed:
			# Mouse button was just pressed
			is_left_mouse_pressed = true
			print("Mouse button pressed!")
			emit_signal("decrease_quantity")

	if is_dragging:
		global_position = get_global_mouse_position()  # Follow the mouse while dragging

	if Input.is_action_just_released("click"):
		stop_dragging()  # Stop dragging when the mouse button is released
		
		# Check if the item has fallen off the screen and delete it
	if not screen_bounds.has_point(global_position):
		emit_signal("increase_quantity")
		queue_free()  # Remove the item from the scene if it's out of bounds
		
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Item clicked!")
		is_dragging = true

# Stop dragging (resume physics and apply a falling impulse)
func stop_dragging() -> void:
	if is_dragging:
		is_dragging = false
		self.freeze = false  # Resume physics behavior
		self.lock_rotation = false  # Unlock rotation to let physics control it
		apply_central_impulse(fall_impulse)  # Apply downward force to simulate falling

# Detect when the item enters the bowl
func _on_Area2D_body_entered(body):
	if body == self:
		if not is_in_bowl:
			print("Item fell into the bowl!")
			is_in_bowl = true  # Mark the item as being in the bowl
			emit_signal("entered_bowl", self)
		
func _on_Area2D_body_exited(body):
	if body == self:
		if is_in_bowl:
			print("Item exited the bowl!")
			is_in_bowl = false  # Mark the item as being in the bowl
			emit_signal("exited_bowl", self)
		
func cleanup():
	# Add any specific logic for cleanup here
	print("Cleaning up ingredient: ")
	queue_free()
	emit_signal("increase_quantity")
