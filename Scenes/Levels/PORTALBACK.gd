extends Area2D

@export var target_location: Vector2

var player_in_target: bool = false
var player: Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact") && player_in_target == true:
		$"../Character".global_position = target_location



func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("Player"):
		player_in_target = true
		player=area

func _on_area_exited(area: Node2D) -> void:
	if area.is_in_group("Player"):
		player_in_target = false
		player=area


