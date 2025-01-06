extends Node

class_name RecipeManager

# Reference to Recipe Database
var recipe_database : RecipeDatabase


func _ready():
	# Load the RecipeDatabase (make sure to assign it in the inspector or load it dynamically)
	recipe_database = load("res://FoodRecipeDatabase/Databases/RecipeDatabase.tres")

# Function to check if the ingredients match a recipe
func bake(ingredients_in_bowl: Array) -> bool:
	# Loop through every recipe in the RecipeDatabase
	for recipe in recipe_database.items:
		# Get the list of ingredients for the current recipe
		var recipe_ingredients = recipe.ingredients

		# Check if all ingredients are present in the bowl
		var ingredients_match = true
		
		# Loop through each ingredient in the recipe
		for ingredient in recipe_ingredients:
			var ingredient_name = ingredient.name
			var found = false
			var recipe_count = 0

			# Count how many times the current ingredient is needed in the recipe
			for bowl_ingredient in ingredients_in_bowl:
				# Access metadata for the ingredient in the bowl
				var bowl_ingredient_data = bowl_ingredient.get_meta("ingredient_data")
				
				# Count how many times the ingredient appears in the bowl
				if bowl_ingredient_data.food_item.name == ingredient_name:
					recipe_count += 1

			# If the number of ingredients in the bowl doesn't meet the recipe's need, fail the match
			if recipe_count < recipe_ingredients.count(ingredient):
				ingredients_match = false
				break

		# If all ingredients match for this recipe, return true
		if ingredients_match:
			print("You made " + recipe.result.name + "!")
			return true

	# If no recipe matches, return false
	return false
