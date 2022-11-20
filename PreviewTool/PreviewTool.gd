extends Control

@onready var SpritePreview = $SpritePreview
@onready var OpenDialog = $OpenDialog
@onready var FilePathInput = $UI/Block/FilePathInput
@onready var SpriteStack = $SpritePreview/SubViewport/SpriteStack
@onready var StackCamera = $SpritePreview/SubViewport/StackCamera

# Sprite Stack
@onready var LayersInput = $UI/Block/SpriteStack/GridContainer/LayersInput
@onready var ZInput = $UI/Block/SpriteStack/GridContainer/ZInput
@onready var YawInput = $UI/Block/SpriteStack/GridContainer/YawInput
@onready var PitchInput = $UI/Block/SpriteStack/GridContainer/PitchInput

# Stack Camera
@onready var RotationInput = $UI/Block/StackCamera/Rotation/RotationInput
@onready var RotationSliderInput = $UI/Block/StackCamera/RotationSlider
@onready var ZoomXInput = $UI/Block/StackCamera/Zoom/ZoomXInput
@onready var ZoomYInput = $UI/Block/StackCamera/Zoom/ZoomYInput


func _on_file_poller_timeout():
	if FilePathInput.text:
		_on_file_dialog_file_selected(FilePathInput.text)


func _on_file_dialog_file_selected(path):
	FilePathInput.text = path
	var image = Image.new()
	var status = image.load(path)
	if (status != OK):
		FilePathInput.add_theme_color_override("font_color", Color.RED)
		return
	FilePathInput.remove_theme_color_override("font_color")
	var texture = ImageTexture.create_from_image(image)
	SpriteStack.sprite_sheet = texture
	SpriteStack.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func _on_text_edit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			OpenDialog.visible = true


func _on_layers_input_text_changed(new_text):
	if not new_text.is_valid_int():
		SpriteStack.layers = LayersInput.placeholder_text.to_int()
		LayersInput.add_theme_color_override("font_color", Color.RED)
		return
	LayersInput.remove_theme_color_override("font_color")
	SpriteStack.layers = new_text.to_int()


func _on_z_input_text_changed(new_text):
	if not new_text.is_valid_int():
		SpriteStack.z = ZInput.placeholder_text.to_int()
		ZInput.add_theme_color_override("font_color", Color.RED)
		return
	ZInput.remove_theme_color_override("font_color")
	SpriteStack.z = new_text.to_int()


func _on_yaw_input_text_changed(new_text):
	if not new_text.is_valid_float():
		SpriteStack.yaw = YawInput.placeholder_text.to_float()
		YawInput.add_theme_color_override("font_color", Color.RED)
		return
	YawInput.remove_theme_color_override("font_color")
	SpriteStack.yaw = deg_to_rad(new_text.to_float())


func _on_pitch_input_text_changed(new_text):
	if not new_text.is_valid_float():
		SpriteStack.pitch = PitchInput.placeholder_text.to_float()
		PitchInput.add_theme_color_override("font_color", Color.RED)
		return
	PitchInput.remove_theme_color_override("font_color")
	SpriteStack.pitch = new_text.to_float()


func _on_rotation_input_text_changed(new_text):
	if not new_text.is_valid_float():
		StackCamera.rotation = RotationInput.placeholder_text.to_float()
		RotationInput.add_theme_color_override("font_color", Color.RED)
		return
	RotationInput.remove_theme_color_override("font_color")
	StackCamera.rotation = deg_to_rad(new_text.to_float())
	RotationSliderInput.value = new_text.to_float()


func _on_rotation_slider_value_changed(value):
	RotationInput.remove_theme_color_override("font_color")
	StackCamera.rotation = deg_to_rad(value)
	
	# Sync up line input if slider moves.
	# Don't sync up if this event fired from the line input syncing up the slider
	# float == float is janky. Solution: https://godotengine.org/qa/32551/comparing-floats
	if (not abs(RotationInput.text.to_float() - value) < 0.000001):
		RotationInput.text = "{f}".format({ "f": value })
	RotationSliderInput.value = value


func _on_zoom_x_input_text_changed(new_text):
	if not new_text.is_valid_float():
		StackCamera.zoom.x = ZoomXInput.placeholder_text.to_float()
		ZoomXInput.add_theme_color_override("font_color", Color.RED)
		return
	ZoomXInput.remove_theme_color_override("font_color")
	StackCamera.zoom.x = new_text.to_float()


func _on_zoom_y_input_text_changed(new_text):
	if not new_text.is_valid_float():
		StackCamera.zoom.y = ZoomYInput.placeholder_text.to_float()
		ZoomYInput.add_theme_color_override("font_color", Color.RED)
		return
	ZoomYInput.remove_theme_color_override("font_color")
	StackCamera.zoom.y = new_text.to_float()


func _on_pixel_size_input_text_changed(new_text):
	if not new_text.is_valid_int():
		SpritePreview.stretch_shrink = LayersInput.placeholder_text.to_int()
		SpritePreview.add_theme_color_override("font_color", Color.RED)
		return
	SpritePreview.remove_theme_color_override("font_color")
	SpritePreview.stretch_shrink = new_text.to_int()
