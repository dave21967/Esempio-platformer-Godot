extends Node2D

var diamonds: int = 0
var diamond_scene = preload("res://Diamond.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for enemy in $Enemies.get_children():
		enemy.connect("dead", self, "_on_enemy_dead")
	
	for diamond in $Diamonds.get_children():
		diamond.connect("catch", self, "_on_catch_diamond")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/GUI/DiamondIcon/Label.text = str(diamonds)

func _on_catch_diamond():
	diamonds += 1

func _on_enemy_dead(pos: Vector2):
	print("Enemy dead")
	var diamond = diamond_scene.instance()
	diamond.position = pos
	diamond.connect("catch", self, "_on_catch_diamond")
	get_node("Diamonds").add_child(diamond)