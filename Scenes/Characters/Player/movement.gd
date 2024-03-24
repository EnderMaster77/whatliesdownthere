extends CharacterBody2D

const SPEED: float = 1000
@export var health: float = 100
var weapons: Array

var selectedweapon
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
		if weapons[0] != null:
			disable_weapons()
			weapons[0].selected = true
			selectedweapon = weapons[0]
		print("Selected Weapon:",weapons[0])
	elif Input.is_action_just_pressed("Switch2"):
		get_weapons()
		if weapons[1] != null:
			disable_weapons()
			weapons[1].selected = true
			selectedweapon = weapons[1]
		print("Selected Weapon:",weapons[1])
	elif Input.is_action_just_pressed("Switch3"):
		get_weapons()
		if weapons[2] != null:
			disable_weapons()			
			weapons[2].selected = true
			selectedweapon = weapons[2]
		print("Selected Weapon:",weapons[2])
	elif Input.is_action_just_pressed("Switch4"):
		get_weapons()
		if weapons[3] != null:
			disable_weapons()
			weapons[3].selected = true
			selectedweapon = weapons[3]
		print("Selected Weapon:",weapons[3])
	if Input.is_action_pressed("Fire"):
		selectedweapon.fire()
	if Input.is_action_just_pressed("Reload"):
		selectedweapon.reload()
	$cursor_location.global_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var movement_dir: Vector2 = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down")).normalized()
	velocity.x = movement_dir.x  * SPEED
	velocity.y = movement_dir.y * SPEED
	move_and_slide()

func get_weapons():
	var node: Node2D
	weapons = []
	for i in $Weapons.get_children():
		print("weapon:", i)
		if i != null:
			weapons.append(i)
	if weapons.size() < 4:
		for i in 4 - weapons.size():
			weapons.append(null)
	print(weapons)
func disable_weapons():
	if weapons[0] != null:
		weapons[0].selected = false
	if weapons[1] != null :
		weapons[1].selected = false
	if weapons[2] != null:
		weapons[2].selected = false
	if weapons[3] != null:
		weapons[3].selected = false
