extends Control

@export var quantity: int = 0  # Starting quantity value
var quantity_label: Label  # The Label node that displays the quantity
var not_enough_money_popup: Popup
var food_name: Label
var inventory_database: InventoryDatabase

var food_database = preload("res://FoodRecipeDatabase/Databases/FoodDatabase.tres")  # Load the FoodDatabase resource

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create an instance of InventoryDatabase if it's not already created
	inventory_database = InventoryDatabase.new()
	
	# Get the reference to the Label and Buttons
	quantity_label = $QuantitySelector/QuantityLabel 
	not_enough_money_popup = get_node("/root/Store/NotEnoughMoney")
	food_name = $FoodName
	
	var increase_button = $QuantitySelector/IncrementButton  
	var decrease_button = $QuantitySelector/DecrementButton  
	var purchase_button = $PurchaseButton
	
	# Set initial quantity in the label
	quantity_label.text = str(quantity)

# Function to handle increase button press
func _on_increment_button_pressed():
	quantity += 1  # Increase the quantity by 1
	quantity_label.text = str(quantity)  # Update the label with the new quantity

# Function to handle decrease button press
func _on_decrement_button_pressed():
	if quantity > 0:  # Prevent the quantity from going below 0
		quantity -= 1  # Decrease the quantity by 1
		quantity_label.text = str(quantity)  # Update the label with the new quantity


func _on_purchase_button_pressed():
	var money_text = get_node("/root/Store/MoneyCount").text
	var money_str = money_text.strip_edges().substr(7, money_text.length())  # Remove "Money: $"
	var money_count = int(money_str)
	print("Current money: ", money_count) 
	
	# Get the food name from the label
	var food_name_str = food_name.text
	print("Food name: ", food_name_str)
	
	# Search the food database for the food item with the matching name
	var food_item: FoodItem = null  # Variable to store the found food item

	for item in food_database.items:
		if item.name == food_name_str:
			food_item = item
			break  # Exit the loop once the item is found
	
	# If the food item is found, continue with the purchase
	if food_item != null:
		print("Food item found: ", food_item.name)
		# Extract the price of the item
		var price = food_item.price
		print("Price is: ", price)

		# Find the total cost of the item(s)
		var total = quantity * price
		print("Total price is: ", total)
		
		# Check if the player has enough money
		if money_count >= total:
			money_count -= total
			# If enough money, subtract from global money
			if Global.subtract_money(total):  # Call the global script method to subtract money
				get_node("/root/Store/MoneyCount").text = "Money: $" + str(money_count)
				print("Purchase successful!")
				
				# Update the inventory
				Global.inventory_database.add_item(food_item, quantity)  # Add item to inventory
				print("Inventory updated:", quantity, " ", food_item.name)
				
			else:
				not_enough_money_popup.popup()
				print("Not enough money to make the purchase.")
		else:
			not_enough_money_popup.popup()
			print("Not enough money to make the purchase.")
	else:
		print("Food item not found in the database.")


	
