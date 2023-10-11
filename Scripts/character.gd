extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 3.0

var mouse_rotation_sensitivity = 0.1
var mouse_look = Vector2(0, 0)

#obtem a gravidade das configurações do projeto para sincronizar com os nós RigidBody.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#variáveis para a corrida
var is_sprinting = false
var normal_speed = SPEED
var sprint_speed = 4.0  #velocidade de corrida mais rápida 

# Variáveis para o agachamento
var is_crouching = false
var crouching_speed = 0.5  #velocidade de caminhar mais lenta

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		mouse_look += event.relative
	
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

	if Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		is_crouching = false

func _physics_process(delta):
	#adiciona a gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	#pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$anim.play("jump")

	#obtem a direção de entrada e lida com o movimento/desaceleração.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		if is_sprinting:
			velocity.x = direction.x * sprint_speed
			velocity.z = direction.z * sprint_speed
			$anim.play("sprint")  #reproduz a animação de sprint quando estiver correndo
		elif is_crouching:
			velocity.x = direction.x * crouching_speed
			velocity.z = direction.z * crouching_speed
			$anim.play("crouch") #reproduz a animação de crouch quando estiver agachado
		else:
			velocity.x = direction.x * normal_speed
			velocity.z = direction.z * normal_speed
			$anim.play("walk")  #reproduz a animação de caminhar quando estiver andando
	else:
		velocity.x = move_toward(velocity.x, 0, normal_speed)
		velocity.z = move_toward(velocity.z, 0, normal_speed)
		$anim.play("idle")

	#rotaciona o personagem com base no movimento do mouse
	mouse_look = clamp(mouse_look, Vector2(-90, -180), Vector2(90, 180))
	rotate_y(deg_to_rad(-mouse_look.x * mouse_rotation_sensitivity))

	mouse_look = Vector2(0, 0)

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_pressed("ui_accept") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
