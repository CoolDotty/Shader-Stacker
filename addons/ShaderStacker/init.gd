@tool
class_name ShaderStacker
extends EditorPlugin


func _enter_tree():
	add_custom_type(
			"SpriteStack", "Node2D",
			preload("res://addons/ShaderStacker/SpriteStack/SpriteStack.gd"), 
			preload("res://addons/ShaderStacker/SpriteStack/icon.svg"))
	add_custom_type(
			"StackCamera", "Camera2D",
			preload("res://addons/ShaderStacker/StackCamera/StackCamera.gd"), 
			preload("res://addons/ShaderStacker/StackCamera/icon.svg"))
	add_custom_type(
			"Reset2D", "Node2D",
			preload("res://addons/ShaderStacker/Reset2D/Reset2D.gd"), 
			preload("res://addons/ShaderStacker/Reset2D/icon.svg"))


func _exit_tree():
	remove_custom_type("SpriteStack")
	remove_custom_type("StackCamera")
	remove_custom_type("Reset2D")
