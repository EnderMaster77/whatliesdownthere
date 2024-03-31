extends Node2D

var sceneName 
var scene_load_status = 0
var progress: Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneName = "res://Scenes/Levels/TestWorldGen.tscn"
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	$Control/Label.text = str(scene_load_status)+ "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newscene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newscene)
