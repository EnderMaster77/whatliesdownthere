extends CharacterBody2D

const SPEED: float = 1000
@export var health: float = 100

var weapon1
var weapon2
var weapon3
var weapon4
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func damage(damage: float):
	health -= damage
	if health <= 0:
		die()

func die():
	health = 100

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Switch1"):
		get_weapons()
	
	if Input.is_action_pressed("Fire"):
		$Weapons/Pistol.fire()
	if Input.is_action_just_pressed("Reload"):
		$Weapons/Pistol.reload()
	$cursor_location.global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var movement_dir: Vector2 = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down")).normalized()
	velocity.x = movement_dir.x  * SPEED
	velocity.y = movement_dir.y * SPEED
	move_and_slide()

func get_weapons():
	var weapons = $Weapons.get_children()
	if weapons.size() == 1:
		weapon1 = weapons[0]
	if weapons.size() == 2:
		weapon2 = weapons[1]
	if weapons.size() == 3:
		weapon3 = weapons[2]
	if weapons.size() >= 4:
		weapon4 = weapons[3]
	print(weapons)
	print([weapon1,weapon2,weapon3,weapon4])
