extends Node2D

# Global money variables
var cat: Node = null
var money: int = 0  # The global money state
var money_per_second: int = 1
var money_timer: Timer
signal global_money_updated(amount: int) # Signal to notify when money has been updated

# Inventory-related variables
var inventory_database: InventoryDatabase  # Reference to the inventory database

# Kitchen-related variables
var is_dragging = false

func _ready():
	var bakery_room = get_tree().root.get_node_or_null("BakeryRoom")

	if bakery_room:
		# Access the Cat node in BakeryRoom
		cat = bakery_room.get_node("Cat")  
		if cat:
			# Connect the signal from the Cat node if it exists
			cat.connect("cat_money_per_second", Callable(self, "_on_cat_money_per_second"))
			print("Connected to Cat node in BakeryRoom!")
			
	# Initialize the inventory database if it hasn't been initialized
	if inventory_database == null:
		inventory_database = InventoryDatabase.new()
		print("Inventory Database Initialized")
	
	# Create and configure a timer
	money_timer = Timer.new()
	add_child(money_timer)  # Add the Timer as a child of the Cat node
	print("Timer added to scene")
	money_timer.wait_time = 1.0  # Set to 1 second
	money_timer.one_shot = false  # Repeats every second
	money_timer.start()  # Start the timer
	print("Timer started")
	money_timer.connect("timeout", Callable(self, "_on_money_timer_timeout"))  # Connect the timeout signal
	print("Timer connected")
	
	print("Global singleton is ready!")
	
func _on_cat_money_per_second(new_value: int):
	# Update the global money_per_second value from the Cat node
	money_per_second = new_value
	print("Global money_per_second updated to: ", money_per_second)
	
func _on_money_timer_timeout():
	#print("Timer triggered!")  # Debugging to see if the function is called
	money += money_per_second  # Add money per second
	Global._on_money_updated(money)  # Notify other nodes of the money update

# This function is called by the Cat node when money is updated
func _on_money_updated(new_money: int):
	money = new_money  # Update the global money value
	emit_signal("global_money_updated", money)  # Inform others about the new money value
	
# Function to subtract money after purchase
func subtract_money(amount: int):
	if money >= amount:
		money -= amount
		emit_signal("global_money_updated", money)  # Notify others about the new money value
		print("Money after purchase: $", money)
		return true  # Return true to indicate the transaction was successful
	else:
		print("Not enough money for purchase.")
		return false  # Return false if there wasn't enough money
