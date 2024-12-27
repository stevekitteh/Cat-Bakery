# Save.gd (to save the money to a file)
extends Node

# Create a FileAccess object
var file : FileAccess

func save_money(amount: int):
	file = FileAccess.open("user://money.save", FileAccess.WRITE)
	if file:
		file.store_line(str(amount))  # Store the money as a string
		file.close()  # Close the file after saving
	else:
		print("Failed to open file for saving.")
