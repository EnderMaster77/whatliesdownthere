extends CharacterBody2D

const SPEED: float = 500

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var LOS_check := $"LOS check" as RayCast2D

@export var max_health: float= 100
@export var health: float = 100
func damage(damage: float):
	health -= damage
	print(health)
	if health <= 0:
		die()

func die():
	print("Died")
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	LOS_check.target_position = to_local(player.global_position)
	if nav_agent.is_target_reached() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity.x = dir.x * SPEED
		velocity.y = dir.y * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	

func makepath() -> void:
	if LOS_check.get_collider() == null:
		return
	elif LOS_check.get_collider().is_in_group("Player"):
		nav_agent.target_position = player.global_position
func _on_timer_timeout() -> void:
	makepath()


func _on_shoot_timer_timeout() -> void:
	if $Spawner.startMode == 2:
		if LOS_check.get_collider() == null:
			return
		elif LOS_check.get_collider().is_in_group("Player"):
			$Spawner.set_manual_start(true)


func _on_spawner_bullet_hit(result: Array, bulletIndex: int, spawner: Object) -> void:
	var object_hit: Node2D = result[0]["collider"]
	print("hit ", object_hit)
	if object_hit.has_method("damage"):
		print("doingdamage")
		object_hit.damage(20.0)

	
