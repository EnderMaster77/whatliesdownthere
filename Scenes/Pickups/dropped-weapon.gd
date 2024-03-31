extends Area2D

var weapon_dropped: PackedScene = preload("res://Scenes/Weapons/EnemyVersions/SMGs/MP5.tscn")

func _ready() -> void:
	print(global_position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("children:",  body.get_child(3).get_child_count())
		var weapon = weapon_dropped.instantiate()
		print("WEAPON:", weapon)
		if body.get_child(3).get_child_count() < 4:
			
			for i in body.get_child(3).get_children():
				if i.weapon_name == weapon.weapon_name:
					i.durability += weapon.durability 
					queue_free()
					return
			weapon.trackedNode = body.get_child(4)
			weapon.clear_all()
			body.get_child(3).add_child(weapon)
			queue_free()
		else:
			for i in body.get_child(3).get_children():
				if i.weapon_name == weapon.weapon_name:
					i.durability += weapon.durability 
					queue_free()
