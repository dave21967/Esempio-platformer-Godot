extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal catch
var tween: Tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(".").add_child(tween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_StaticBody2D_body_entered(body:Node):
	if body.name == "Player":
		emit_signal("catch")
		$AnimationPlayer.play("fade")
		tween.interpolate_property(self, "position", position, Vector2(position.x, position.y-50), 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func _on_AnimationPlayer_animation_finished(anim_name:String):
	queue_free()