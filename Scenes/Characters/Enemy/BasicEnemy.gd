extends CharacterBody2D

const SPEED: float = 500

@export var player: Node2D
var healthpackfab = preload("res://Scenes/Pickups/healthpack.tscn")
var ammofab := preload("res://Scenes/Pickups/ammo-pistol.tscn")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var LOS_check := $"LOS check" as RayCast2D
var on_screen: bool = false
@export var max_health: float= 100
@export var health: float = 50
func damage(damage: float):
	health -= damage
	
	if health <= 0:
		randomize()
		var r = randf()
		print(r)
		if r >= .50:
			var randnum: float = randf()
			if randnum > .80:
				print("Drop Weapon")
			elif randnum > 0.40:
				var pack = healthpackfab.instantiate()
				pack.global_position = global_position
				add_sibling(pack)
				pack.scale = scale
				pack.global_position = global_position
			else:
				var pack = ammofab.instantiate()
				pack.global_position = global_position
				add_sibling(pack)
				pack.scale = scale
				pack.global_position = global_position
		else:
			print("FAIL!!")
		die()

func die():
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		LOS_check.target_position = to_local(player.global_position)
	if nav_agent.is_target_reached() == false:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		velocity.x = dir.x * SPEED
		velocity.y = dir.y * SPEED
	else:
		velocity = Vector2.ZERO
	if $Weapon.can_fire == true:
		if LOS_check.get_collider() == null:
			return
		elif LOS_check.get_collider().is_in_group("Player") && on_screen == true:
			$Weapon.fire()
	move_and_slide()
	

func makepath() -> void:
	if LOS_check.get_collider() == null:
		return
	elif LOS_check.get_collider().is_in_group("Player") && on_screen == true:
		nav_agent.target_position = player.global_position
func _on_timer_timeout() -> void:
	makepath()




func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
