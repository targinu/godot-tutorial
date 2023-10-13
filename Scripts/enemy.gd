extends CharacterBody3D

var enemyHP = 3
var damage = 1

var attackDistance = 1.0
var attackRate = 1.0
var enemySpeed = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var timer = $attackTimer as Timer
@onready var player = get_node_or_null("/root/World/character-skeleton")

func _ready():
	timer.wait_time = attackRate
	timer.start()

func _physics_process(delta):
	
	#adiciona a gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Move o inimigo em direção ao jogador se o jogador estiver dentro de uma certa distância.
	if player and player.get_global_transform().origin.distance_to(global_transform.origin) < 5.0:
		var player_direction = (player.global_transform.origin - global_transform.origin).normalized()
		velocity += player_direction * enemySpeed

	move_and_slide()

func takeDamage(damage):
	enemyHP -= damage
	
	if enemyHP <= 0:
		die()

func die():
	queue_free()


func _on_attack_timer_timeout():
	if position.distance_to(player.position) <= attackDistance:
		player.takeDamage(damage)
