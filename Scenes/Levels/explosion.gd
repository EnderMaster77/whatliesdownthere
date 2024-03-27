extends Area2D
var particle = preload("res://Scenes/Extras/explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = 500



func _on_area_entered(area: Area2D) -> void:
	if area.has_method("Damage"):
		area.damage(200)
	print("Hit ", area)
	

func _on_area_exited(area: Area2D) -> void:
	if area.has_method("damage"):
		area.damage(200)
	print("Hit ", area)


func _on_timer_timeout() -> void:
	$CollisionShape2D.shape.radius = 0.01
	var part = particle.instantiate()
	part.global_position = global_position
	part.emitting = true
	part.one_shot = true
	get_parent().add_child(part)
	queue_free()
