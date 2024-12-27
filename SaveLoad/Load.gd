# Load.gd (to load the money from a file)
extends Node

# Create a FileAccess object
var file : FileAccess

func load_money() -> int:
	var saved_money : int = 0
	file = FileAccess.open("user://money.save", FileAccess.READ)
	if file:
		var line = file.get_line()  # Read the line (money value as string)
		saved_money = int(line)  # Convert the string to an integer
		file.close()  # Close the file after reading
	else:
		print("Failed to open file for loading.")
	return saved_money
