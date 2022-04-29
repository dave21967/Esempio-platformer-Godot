extends KinematicBody2D

enum States {
	IDLE,
	RUN,
	JUMP
}

var velocity: Vector2 = Vector2(0,0)
var speed: int = 250
var jump: int = 350
var gravity: int = 400
var life: float = 100
var time: float = 0
var vulnerable: bool = true
onready var tween: Tween = get_node("Tween")

var state = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_input():
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	var jumping = Input.is_action_just_pressed("jump")
	if left:
		velocity.x = -speed
		state = States.RUN
		$AnimatedSprite.flip_h = true
	if right:
		velocity.x = speed
		state = States.RUN
		$AnimatedSprite.flip_h = false
	if jumping and is_on_floor():
		state = States.JUMP
		velocity.y = -jump
	if not left and not right and is_on_floor():
		velocity.x = 0
		state = States.IDLE
	
func get_damage(dam: int):
	if vulnerable:
		var rng: RandomNumberGenerator = RandomNumberGenerator.new()
		tween.interpolate_property(self, "life", life, life-dam, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		time = 0
		vulnerable = false

func check_vulnerability():
	if int(time) >= 2:
		vulnerable = true

func _animation_update():
	match state:
		States.IDLE:
			$AnimatedSprite.play("idle")
		States.RUN:
			$AnimatedSprite.play("run")
		States.JUMP:
			$AnimatedSprite.play("jump")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	check_vulnerability()
	if not vulnerable:
		modulate.a = 0.5
	else:
		modulate.a = 1
	_animation_update()
	$GUI/HelthBarDecoration/TextureProgress.value = life
	if not is_on_floor():
		if velocity.y < 0:
			state = States.JUMP
		velocity.y += delta * gravity
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider.has_method("die"):
				collider.die()
	if is_on_ceiling():
		velocity.y = gravity
	get_input()
	move_and_slide(velocity, Vector2(0, -1))
