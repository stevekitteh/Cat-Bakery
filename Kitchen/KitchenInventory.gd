extends Node2D

# UI References
@onready var ingredient_panel = $IngredientPanel  # PopupPanel
@onready var hbox_container = $IngredientPanel/ItemContainer  # Container inside PopupPanel
@onready var menu_button = $MenuButton  # MenuButton for opening inventory
@onready var not_enough_label = $NotEnoughLabel

# Popup State
var button_y: float
var is_popup_open: bool = false

# List to keep track of dynamically created nodes
var ingredients = []


func _ready():
	button_y = menu_button.position.y
	
	ingredient_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	load_inventory()

# Load Inventory Items into Popup
func load_inventory():
	# Get inventory data
	var inventory = Global.inventory_database.items
	
	# Clear previous items
	for child in hbox_container.get_children():
		child.queue_free()
	
	# Populate items
	for inventory_item in inventory:
		var item_box = create_inventory_item(inventory_item)
		hbox_container.add_child(item_box)

# Create Individual Inventory Item
func create_inventory_item(inventory_item):
	# VBoxContainer for item
	var item_box = VBoxContainer.new()

	# Area2D to handle input
	var click_area = Area2D.new()
	click_area.name = "ClickArea"
	
	click_area.collision_layer = 1
	click_area.collision_mask = 1

	# Add a CollisionShape2D to define the clickable area
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	click_area.add_child(collision_shape)

	# Item Sprite
	var item_sprite = TextureRect.new()
	item_sprite.texture = inventory_item.food_item.sprite
	item_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	item_sprite.expand_mode = true
	item_sprite.custom_minimum_size = Vector2(100, 100)
	item_sprite.name = "IngredientSprite"
	item_box.add_child(item_sprite)

	# Calculate the scaled size of the sprite and change the location
	var sprite_size = item_sprite.custom_minimum_size * item_sprite.scale
	(collision_shape.shape as RectangleShape2D).extents = sprite_size / 2
	click_area.position = item_sprite.position + (sprite_size / 2)
	item_box.add_child(click_area)  # Add the click area to the item box

	# Item Name and Quantity
	var item_name_quantity = Label.new()
	item_name_quantity.set("theme_override_font_sizes/font_size", 15)
	item_name_quantity.text = inventory_item.food_item.name + " x" + str(inventory_item.quantity)
	item_name_quantity.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	item_box.add_child(item_name_quantity)

	# Connect the Area2D input signal
	click_area.connect("input_event", Callable(self, "_on_area_input").bind(inventory_item))

	return item_box
	
func _on_area_input(viewport, event, shape_idx, inventory_item):
	#print("clicked")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and inventory_item.quantity > 0:
		# Create the Node2D
		var drag_node = RigidBody2D.new()
		drag_node.name = "DraggedIngredient"
		
		# Attach IngredientMove.gd script
		drag_node.set_script(preload("res://Kitchen/IngredientMove.gd"))
		ingredients.append(drag_node)
		
		# Create the Sprite2D
		var sprite_node = Sprite2D.new()
		sprite_node.texture = inventory_item.food_item.sprite
		sprite_node.scale = Vector2(0.4, 0.4) 
		drag_node.add_child(sprite_node)
		
		# Create the CollisionShape2D and set the shape
		var collision_node = CollisionShape2D.new()
		var collision_shape = RectangleShape2D.new()
		collision_shape.extents = sprite_node.texture.get_size() * sprite_node.scale / 2
		collision_node.shape = collision_shape
		drag_node.add_child(collision_node)

		# Set the position to the mouse
		drag_node.global_position = get_global_mouse_position()

		# Add the Node2D to the scene
		get_tree().root.add_child(drag_node)
		
		# Connect the signals for increasing/decreasing quantity
		drag_node.connect("increase_quantity", Callable(self, "_on_increase_quantity").bind(inventory_item))
		drag_node.connect("decrease_quantity", Callable(self, "_on_decrease_quantity").bind(inventory_item))
		
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and inventory_item.quantity <= 0:
		print("Cannot decrease quantity below 0!")
		show_fading_message(inventory_item.food_item.name)
		
# Handle signal when quantity is decreased
func _on_decrease_quantity(inventory_item):
	if inventory_item.quantity > 0:
		print("Item quantity decreased!")
		inventory_item.quantity -= 1
		load_inventory()

# Handle signal when quantity is increased
func _on_increase_quantity(inventory_item):
	print("Item quantity increased!")
	inventory_item.quantity += 1
	load_inventory()
	
func show_fading_message(ingredient: String):
	# Set the dynamic message and ensure the label is visible
	not_enough_label.text = "You don't have enough " + ingredient + "!"
	
	# Style the text: set it to black and adjust the font size
	not_enough_label.set("theme_override_font_sizes/font_size", 25)
	not_enough_label.set("theme_override_colors/font_color", Color(0, 0, 0))
	
	not_enough_label.modulate.a = 1.0  # Fully opaque
	not_enough_label.visible = true

	# Create a tween from the scene tree
	var tween = get_tree().create_tween()

	# Animate the fade-out (alpha from 1.0 to 0.0 over 3 seconds)
	tween.tween_property(not_enough_label, "modulate:a", 0.0, 2.0)

	# Queue the label to be hidden after the animation ends
	tween.tween_callback(Callable(self, "_on_tween_complete"))
	
func cleanup_ingredients():
	for ingredient in ingredients:
		if ingredient != null and ingredient.is_inside_tree():
			ingredient.cleanup()  # Call the cleanup function in IngredientMove
	ingredients.clear()  # Clear the list after all nodes are freed
	
# Connect the MenuButton signal to show the inventory menu
func _on_menu_button_pressed():
	if is_popup_open:
		ingredient_panel.visible = false  # Hide the PopupPanel if it's already visible
		menu_button.position.y = button_y  # Reset to the original position
		is_popup_open = false
		
	else:
		ingredient_panel.visible = true  # Show the PopupPanel centered on the screen
		menu_button.position.y = button_y - 138  # Move it up by 100 unitsn.y - 100)
		is_popup_open = true
		
func _on_back_button_pressed():
	print("Back button pressed!")  # Check if the button is responding
	cleanup_ingredients()
	get_tree().change_scene_to_file("res://BakeryRoom.tscn")
	
