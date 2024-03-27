extends Node
class_name Walker

const DIRECTIONS: Array = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.RIGHT
var borders: Rect2 = Rect2()
var step_history = []
var steps_since_turn = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
