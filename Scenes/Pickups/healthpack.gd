extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if area.health >= 100:
			return
		elif area.health + 30 > 100:
			area.health = 100
			queue_free()
		else:
			area.health += 30
			queue_free()
		print(area.health)
	print(area)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.health >= 100:
			return
		elif body.health + 30 > 100:
			body.health = 100
			queue_free()
		else:
			body.health += 30
			queue_free()
		print(body.health)
	print(body)
