extends CharacterBody2D

const SPEED: float = 1000
@export var health: float = 100
var weapons: Array
var selectedweapon
var dashing: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash: bool = true


@export var max_ammo: Dictionary = {"Pistol":0,
						"AR":0,
						"Shotgun":0,
						"Energy": 0,
						"Special":0,
						"Sniper": 0}

@export var ammo: Dictionary = {
						"Pistol":0,
						"AR":0,
						"Shotgun":0,
						"Energy": 0,
						"Special":0,
						"Sniper": 0}







func damage(damage: float):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

func _process(delta: float) -> void:
	$gun_sprite.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("Switch1"):
		get_weapons()
		if weapons[0] != null:
			disable_weapons()
			weapons[0].selected = true
			selectedweapon = weapons[0]
			$gun_sprite.texture = selectedweapon.gun_texture
		print("Selected Weapon:",weapons[0])
	elif Input.is_action_just_pressed("Switch2"):
		get_weapons()
		if weapons[1] != null:
			disable_weapons()
			weapons[1].selected = true
			selectedweapon = weapons[1]
			$gun_sprite.texture = selectedweapon.gun_texture
		print("Selected Weapon:",weapons[1])
	elif Input.is_action_just_pressed("Switch3"):
		get_weapons()
		if weapons[2] != null:
			disable_weapons()			
			weapons[2].selected = true
			selectedweapon = weapons[2]
			$gun_sprite.texture = selectedweapon.gun_texture
		print("Selected Weapon:",weapons[2])
	elif Input.is_action_just_pressed("Switch4"):
		get_weapons()
		if weapons[3] != null:
			disable_weapons()
			weapons[3].selected = true
			selectedweapon = weapons[3]
			$gun_sprite.texture = selectedweapon.gun_texture
			
		print("Selected Weapon:",weapons[3])
	if Input.is_action_pressed("Fire") && selectedweapon != null:
		selectedweapon.fire()
	if Input.is_action_just_pressed("Reload") && selectedweapon != null:
		selectedweapon.reload()
	if Input.is_action_just_pressed("Throw Weapon") && selectedweapon != null:
		selectedweapon.throw()
		$gun_sprite.texture = null
		selectedweapon = null
	$cursor_location.global_position = get_global_mouse_position()
	if selectedweapon != null:
		$CanvasLayer/Gui/Control/Label.text = str(selectedweapon.name)
		$CanvasLayer/Gui/Control/Label2.text = str(selectedweapon.bullets_in_mag)
		$CanvasLayer/Gui/Control/Label3.text = str(ammo[selectedweapon.ammo_type])
		$CanvasLayer/Gui/Control/Label4.text = str(selectedweapon.durability)
	else:
		$CanvasLayer/Gui/Control/Label.text = "None"
		$CanvasLayer/Gui/Control/Label2.text = "N/A"
		$CanvasLayer/Gui/Control/Label3.text = "N/A"
		$CanvasLayer/Gui/Control/Label4.text = "N/A"
	$Health.value = health








func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Dash") && can_dash == true:
		$DashTimer.start()
		can_dash = false
		dashing = true
		velocity *= 4
		$hitbox.collision_layer = 0
		$hitbox.collision_mask = 0
	if dashing == false:
		var movement_dir: Vector2 = Vector2(Input.get_axis("Left","Right"), Input.get_axis("Up","Down")).normalized()
		velocity.x = movement_dir.x  * SPEED
		velocity.y = movement_dir.y * SPEED
	else:
		velocity
	move_and_slide()








func get_weapons():
	var node: Node2D
	weapons = []
	for i in $Weapons.get_children():
		if i != null:
			weapons.append(i)
	if weapons.size() < 4:
		for i in 4 - weapons.size():
			weapons.append(null)
func disable_weapons():
	if weapons[0] != null:
		weapons[0].selected = false
	if weapons[1] != null :
		weapons[1].selected = false
	if weapons[2] != null:
		weapons[2].selected = false
	if weapons[3] != null:
		weapons[3].selected = false


func _on_dash_timer_timeout() -> void:
	$can_dash_timer.start()
	$hitbox.collision_layer = 2
	$hitbox.collision_mask = 2
	dashing = false


func _on_can_dash_timer_timeout() -> void:
	print("DASH")
	can_dash = true


func _on_tptolevel_start() -> void:
	$CanvasLayer/Gui/Control/TextureRect.show()


func _on_tptolevel_finished() -> void:
	$CanvasLayer/Gui/Control/TextureRect.hide()
