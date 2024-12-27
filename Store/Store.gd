extends Node2D

var money_label: Label


# Called when the node enters the scene tree for the first time.
func _ready():
	money_label = $MoneyCount  # The Label node in your BakeryRoom scene

	Global.connect("global_money_updated", Callable(self, "_on_money_updated"))
	_on_money_updated(Global.money)  # Set the initial label value
	
	# Disconnect the signal after the first update to avoid continuous updates
	Global.disconnect("global_money_updated", Callable(self, "_on_money_updated"))

# This function will be called whenever the cat earns money
func _on_money_updated(amount: int):
	# Update the label to show the current amount of money
	money_label.text = "Money: $" + str(amount)  # Update the label with the new money value



func _on_back_button_pressed():
	print("Back button pressed!")  # Check if the button is responding
# Proceed with the back button logic (e.g., change scene, hide the store, etc.)
#get_tree().change_scene("res://path/to/previous_scene.tscn")
	get_tree().change_scene_to_file("res://BakeryRoom.tscn")
