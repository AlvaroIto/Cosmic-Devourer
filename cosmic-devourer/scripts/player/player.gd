extends CharacterBody2D

@export var speed: float = 300.0
@export var mass: float = 10.0
@export var gravity_range_base: float = 75.0
@export var gravity_range_per_mass: float = 3.0
@export var player_size: int = 1

func _physics_process(_delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	velocity = direction * speed
	move_and_slide()

func collect_mass(amount: float):
	mass += amount
	
	if mass >= 80:
		player_size = 4
	elif mass >= 40:
		player_size = 3
	elif mass >= 20:
		player_size = 2
	else:
		player_size = 1
	
	var player_radius = 30.0 + (mass - 10.0) * 3.0
	$CollisionShape2D.shape.radius = player_radius
	
	var gravity_range = gravity_range_base + (mass - 10.0) * gravity_range_per_mass

	print("Massa: ", mass)
	print("Alcance da gravidade: ", gravity_range)

	queue_redraw()
	
	print("Massa atual: ", mass)

func _draw():
	var gravity_range = gravity_range_base + (mass - 10.0) * gravity_range_per_mass

	draw_arc(
		Vector2.ZERO,
		gravity_range,
		0.0,
		TAU,
		64,
		Color(0.4, 0.7, 1.0, 0.3),
		2.0
	)
	
	var player_radius = 30.0 + (mass - 10.0) * 3.0

	draw_circle(Vector2.ZERO, player_radius, Color(0.35, 0.35, 0.35))
	draw_circle(Vector2(-10, -8), 5.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(9, 5), 7.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(3, -13), 3.0, Color(0.18, 0.18, 0.18))
