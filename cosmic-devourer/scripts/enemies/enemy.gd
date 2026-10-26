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


	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if not body is CharacterBody2D:
			continue

		if not body.is_in_group("enemies"):
			continue

		if body == self:
			continue

		var difference = mass - body.mass

		if difference > 0:
			var impact_direction = (body.global_position - global_position).normalized()
			var push_force = clamp(difference * 3.0, 80.0, 400.0)

			body.velocity += impact_direction * push_force
			collect_mass(body.mass)
			body.queue_free()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if not body is CharacterBody2D:
			continue

		if not body.is_in_group("enemies"):
			continue

		if body == self:
			continue

		var difference = mass - body.mass

		if difference > 0:
			var impact_direction = (body.global_position - global_position).normalized()
			var push_force = clamp(difference * 3.0, 80.0, 400.0)

			body.velocity += impact_direction * push_force
			collect_mass(body.mass)
			body.queue_free()

	if global_position.x < -100 or global_position.x > 2020 or global_position.y < -100 or global_position.y > 1180:
		direction = global_position.direction_to(Vector2(960, 540))

func collect_mass(amount: float):
	mass += amount
	update_from_mass()

func find_target():
	target = null
	var closest_distance = INF

	# Prioridade 1: procurar asteroides menores
	for asteroid in get_tree().get_nodes_in_group("asteroids"):
		if asteroid.mass < mass:
			var distance = global_position.distance_to(asteroid.global_position)

			if distance < closest_distance:
				closest_distance = distance
				target = asteroid

	# Se encontrou um asteroide, manter esse alvo
	if target != null:
		return

	# Prioridade 2: procurar outros Enemies menores
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy == self:
			continue

		if enemy.mass < mass:
			var distance = global_position.distance_to(enemy.global_position)

			if distance < closest_distance:
				closest_distance = distance
				target = enemy
