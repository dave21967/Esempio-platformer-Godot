extends KinematicBody2D

var speed: int = 200
var velocity: Vector2 = Vector2(speed,0)
var time = 0
var damage = 10
signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("idle")

func _handle_ai():
	if int(time) == 3:
		velocity.x = -velocity.x
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$AttackRange.cast_to = -$AttackRange.cast_to
		time = 0

func die():
	emit_signal("dead", position)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	_handle_ai()
	if $AttackRange.is_colliding():
		var collider = $AttackRange.get_collider()
		if collider.has_method("get_damage"):
			collider.get_damage(30)
	move_and_slide(velocity)
