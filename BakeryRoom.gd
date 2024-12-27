extends Node2D

var cat: Node  # Reference to the Cat node
var money_label: Label  # Reference to the MoneyCount label

func _ready():
	print("Welcome to the bakery!")
	# Initialize references to the Cat node and the MoneyCount label
	cat = $Cat  # Adjust if Cat is under another parent
	money_label = $MoneyCount  # The Label node in your BakeryRoom scene

	Global.connect("global_money_updated", Callable(self, "_on_money_updated"))
	_on_money_updated(Global.money)  # Set the initial label value

# This function will be called whenever the cat earns money
func _on_money_updated(amount: int):
	# Update the label to show the current amount of money
	money_label.text = "Money: $" + str(amount)  # Update the label with the new money value

func _on_shop_button_pressed():
	get_tree().change_scene_to_file("res://Store.tscn")
	
func _on_inventory_button_pressed():
	get_tree().change_scene_to_file("res://Inventory.tscn")


func _on_kitchen_button_pressed():
	get_tree().change_scene_to_file("res://Kitchen.tscn")
