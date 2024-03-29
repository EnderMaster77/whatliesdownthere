extends Area2D

@export_enum("AR","Shotgun","Pistol","Energy","Special","Rocket","Sniper") var ammo_type = "AR"

@export var ammo_gained: int = 50


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if area.ammo[ammo_type] >= area.max_ammo[ammo_type]:
			return
		elif area.ammo[ammo_type] + ammo_gained > area.max_ammo[ammo_type]:
			area.ammo[ammo_type] = area.max_ammo[ammo_type]
			queue_free()
		else:
			area.ammo[ammo_type] += ammo_gained
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.ammo[ammo_type] >= body.max_ammo[ammo_type]:
			return
		elif body.ammo[ammo_type] + ammo_gained > body.max_ammo[ammo_type]:
			body.ammo[ammo_type] = body.max_ammo[ammo_type]
			queue_free()
		else:
			body.ammo[ammo_type] += ammo_gained
			queue_free()
