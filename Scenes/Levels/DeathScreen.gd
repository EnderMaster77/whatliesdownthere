extends CanvasLayer

var load_screen = preload("res://Scenes/Menus/loading.tscn")
var mainmenu: PackedScene = preload("res://Scenes/Menus/MainMenu.tscn")

func _on_button_pressed() -> void:
	if visible == true:
		get_tree().change_scene_to_packed(load_screen)


func _on_button_2_pressed() -> void:
	if visible == true:
		get_tree().quit()


func _on_button_3_pressed() -> void:
	if visible == true:
		get_tree().change_scene_to_packed(mainmenu)
