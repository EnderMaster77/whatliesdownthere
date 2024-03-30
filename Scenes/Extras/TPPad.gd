extends Area2D

@export var target_location: Vector2 = Vector2.ZERO
@export var enabled: bool = false
@export var floor_tile: Vector2i
@export var wall_tile: Vector2i
@export var weapon1: PackedScene
@export var weapon2: PackedScene
var player_in_target: bool = false
var player: Node2D
var started: bool = false

signal start
signal finished
#GENERATE FROM HERE!!!
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && player_in_target == true:
		started = true
		start.emit()
		get_parent().generate(floor_tile, wall_tile, weapon1, weapon2)
		$"../Bordertimer".start()
		hide()



func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("Player"):
		player_in_target = true
		player=area

func _on_area_exited(area: Node2D) -> void:
	if area.is_in_group("Player"):
		player_in_target = false
		player=area
		started = false


func _on_world_gen_finished() -> void:
	print("EMMITING")
	if started == true:
		$"../Character".global_position = target_location
		finished.emit()
