extends Camera2D

func _process(delta: float) -> void:
	if $"../Character" != null:
		global_position = $"../Character".global_position
