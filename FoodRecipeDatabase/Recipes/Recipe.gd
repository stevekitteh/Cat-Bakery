extends Resource
class_name Recipe

@export var name: String
@export var description: String
#@export var sprite: Texture2D  # Image?
@export var ingredients: Array[FoodItem]
@export var result: CookedItem
@export var unlocked: bool = false
