extends CharacterBody2D

@export var mass: float = 10.0
@export var radius: float = 30.0
@export var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO
var target: Node2D = null

func _ready():
	update_from_mass()
	add_to_group("enemies")
	queue_redraw()
	direction = Vector2.from_angle(randf_range(0.0, TAU))

func update_from_mass():
	if mass < 10:
		radius = 20.0
	elif mass < 20:
		radius = 30.0
	elif mass < 40:
		radius = 40.0
	else:
		radius = 50.0

	$CollisionShape2D.shape.radius = radius
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, Color(0.55, 0.35, 0.35))
	draw_circle(Vector2(-5, -5), radius * 0.25, Color(0.35, 0.20, 0.20))

func _physics_process(_delta):
	if target == null or not is_instance_valid(target):
		find_target()

	if target != null:
		direction = global_position.direction_to(target.global_position)
	else:
		if randf() < 0.02:
			direction = Vector2.from_angle(randf_range(0.0, TAU))

	velocity = direction * speed
	move_and_slide()

	if global_position.x < -100 or global_position.x > 1300 or global_position.y < -100 or global_position.y > 700:
		direction = global_position.direction_to(Vector2(600, 350))

func collect_mass(amount: float):
	mass += amount
	update_from_mass()


func find_target():
	target = null
	var closest_distance = INF

	# Procurar asteroides menores
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		if asteroid.mass < mass:
			var distance = global_position.distance_to(asteroid.global_position)

			if distance < closest_distance:
				closest_distance = distance
				target = asteroid

	# Procurar outros Enemies menores
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy == self:
			continue

		if enemy.mass < mass:
			var distance = global_position.distance_to(enemy.global_position)

			if distance < closest_distance:
				closest_distance = distance
				target = enemy
