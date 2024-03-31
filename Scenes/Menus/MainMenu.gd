extends Control


var load_screen = preload("res://Scenes/Menus/loading.tscn")
var Level_Scene: PackedScene = preload("res://Scenes/Levels/TestWorldGen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	print("START PRESSED!")
	get_tree().change_scene_to_packed(load_screen)

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_2_pressed() -> void:
	$Credits.show()
	$Label.hide()
	$Start.hide()
	$Credits2.hide()
	$Quit.hide()


func _on_back_pressed() -> void:
	$Credits.hide()
	$Label.show()
	$Start.show()
	$Credits2.show()
	$Quit.show()
