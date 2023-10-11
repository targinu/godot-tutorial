extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node) -> void:
	print("O Player colidiu")
	$anim.play("collect")
	$anim.speed_scale = 2.0 
	await get_tree().create_timer(0.4).timeout
	queue_free()
