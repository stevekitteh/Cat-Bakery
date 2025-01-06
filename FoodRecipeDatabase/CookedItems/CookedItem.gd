extends Resource
class_name CookedItem

@export var name: String
@export var description: String
@export var sprite: Texture2D  
@export var ingredients: Array[FoodItem]  # List of food items required for the recipe
@export var unlocked: bool = false  # Whether the recipe is unlocked and can be used
