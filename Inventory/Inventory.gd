extends Node2D

# Reference to the PopupPanel and VBoxContainer
#@onready var ingredient_panel = $IngredientPanel  # Path to your PopupPanel node
@onready var vbox_container = $InventoryBox  # Path to VBoxContainer inside PopupPanel


func _ready():
	# Connect the "pressed" signal to the function that will display the popup
	load_inventory()

# Function to load the inventory and populate the PopupPanel
func load_inventory():
	# Get the inventory data (this assumes you have a global inventory database or array)
	var inventory = Global.inventory_database.items
	
	# Clear the VBoxContainer before adding new items
	for child in vbox_container.get_children():
		child.queue_free()  # Free the memory of each child
	
	# Iterate through the inventory items and create UI elements for each item
	for inventory_item in inventory:
		# Create a VBoxContainer for each item to hold its sprite, name, and quantity
		var item_box = HBoxContainer.new()
		
		# Add the item's sprite
		var item_sprite = TextureRect.new()
		item_sprite.texture = inventory_item.food_item.sprite  # Assuming food_item has a sprite property
		item_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		item_sprite.expand_mode = true
		item_sprite.custom_minimum_size = Vector2(100, 100)  # Adjust size as needed
		item_box.add_child(item_sprite)
		
		# Add the item's name and quantity
		var item_name_label = Label.new()
		item_name_label.text = inventory_item.food_item.name + " x" + str(inventory_item.quantity)
		item_name_label.set("theme_override_font_sizes/font_size", 40)
		item_name_label.set("theme_override_colors/font_color", Color(0, 0, 0))
		item_box.add_child(item_name_label)
		
		# Add the item_box (which holds the sprite and label) to the VBoxContainer
		vbox_container.add_child(item_box)
		

func _on_back_button_pressed():
	print("Back button pressed!")  # Check if the button is responding
	get_tree().change_scene_to_file("res://BakeryRoom.tscn")
