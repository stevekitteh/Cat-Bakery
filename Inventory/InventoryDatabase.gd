extends Resource

class_name InventoryDatabase

@export var items: Array = []  # List of InventoryItem resources

# Function to add or update an item in the inventory
func add_item(food_item: FoodItem, quantity: int):
	for inventory_item in items:
		if inventory_item.food_item == food_item:
			inventory_item.quantity += quantity  # Increase quantity if item exists
			return
	# If item doesn't exist, add a new InventoryItem
	var new_inventory_item = InventoryItem.new()
	new_inventory_item.food_item = food_item
	new_inventory_item.quantity = quantity
	items.append(new_inventory_item)

# Function to remove items from the inventory
func remove_item(food_item: FoodItem, quantity: int) -> bool:
	for inventory_item in items:
		if inventory_item.food_item == food_item and inventory_item.quantity >= quantity:
			inventory_item.quantity -= quantity
			if inventory_item.quantity <= 0:
				items.erase(inventory_item)  # Remove item if quantity is 0
			return true
	return false
