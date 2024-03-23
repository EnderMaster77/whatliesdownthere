extends CharacterBody2D

const SPEED: float = 1000
@export var health: float = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func damage(damage: float):
	health -= damage
	print(health)
	if health <= 0:
		die()

func die():
	print("Died")
	health = 100

func _process(delta: float) -> void:
	if Input.is_action_pressed("Fire"):
		$Weapons/Pistol.fire()
	$cursor_location.global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var movement_dir: Vector2 = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down")).normalized()
	velocity.x = movement_dir.x  * SPEED
	velocity.y = movement_dir.y * SPEED
	move_and_slide()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print(area)
	print("Hit2")


func _on_spawner_bullet_hit(result: Array, bulletIndex: int, spawner: Object) -> void:
	var object_hit: Node2D = result[0]["collider"]
	print("hit ", object_hit)
	if object_hit.has_method("damage"):
		print("doingdamage")
		object_hit.damage($Weapons/Spawner.homingWeight)

