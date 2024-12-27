extends Control

# This is the UI container to hold the inventory UI elements (like buttons or labels)
@onready var inventory_panel = self  # Reference to the panel where inventory items will be added

# Call this function when the scene is ready to populate the UI
func _ready():
	load_inventory()

# Function to load the inventory items from the global inventory database
func load_inventory():
	# Access the global InventoryDatabase instance
	var inventory = Global.inventory_database.items

	# Iterate over all items in the inventory
	for inventory_item in inventory:
		add_theme_constant_override("separation", 10)
		
		var item_box = HBoxContainer.new()

		# Create and set up the sprite for the food item
		var item_sprite = TextureRect.new()
		item_sprite.texture = inventory_item.food_item.sprite  # Assuming FoodItem has a 'sprite' property
		item_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT  # Preserve aspect ratio # Optional: Center horizontally
		item_sprite.expand_mode = true
		item_sprite.custom_minimum_size = Vector2(100, 100)
		item_box.add_child(item_sprite)
		
		#var font = FontFile.new()
		#font = load("res://Fonts/Roboto-Regular.ttf")
		#
		
		# Create and set up the label for the food item name
		var item_name_label = Label.new()
		item_name_label.text = inventory_item.food_item.name  # Assuming FoodItem has a 'name' property
		
		item_name_label.set("theme_override_font_sizes/font_size", 40)
		item_name_label.set("theme_override_colors/font_color", Color(0, 0, 0))
		item_box.add_child(item_name_label)

		# Create and set up the label for the food item quantity
		var item_quantity_label = Label.new()
		item_quantity_label.text = " " + str(inventory_item.quantity)  # Show the quantity of the item
		item_quantity_label.set("theme_override_font_sizes/font_size", 40)
		item_quantity_label.set("theme_override_colors/font_color", Color(0, 0, 0))
		item_box.add_child(item_quantity_label)
		
		inventory_panel.add_child(item_box)
		
