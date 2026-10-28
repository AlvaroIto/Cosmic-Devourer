extends CharacterBody2D

@export var speed: float = 300.0
@export var mass: float = 10.0
@export var gravity_range_base: float = 0
@export var gravity_range_per_mass: float = 0
@export var player_size: int = 1
@export var camera_zoom_min: float = 0.65
@export var camera_zoom_mass_factor: float = 0.003
@export var camera_zoom_smoothing: float = 2.0

func _physics_process(_delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	
	velocity = direction * speed
	move_and_slide()
	update_camera_zoom(_delta)

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
	
	var player_radius = 30.0 + (mass - 10.0) * 0.8
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
	
	var player_radius = 30.0 + (mass - 10.0) * 0.8

	draw_circle(Vector2.ZERO, player_radius, Color(0.35, 0.35, 0.35))
	draw_circle(Vector2(-10, -8), 5.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(9, 5), 7.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(3, -13), 3.0, Color(0.18, 0.18, 0.18))

func update_camera_zoom(delta: float):
	var camera = get_node_or_null("Camera2D")

	if camera == null:
		return

	var target_zoom = 1.0 / (1.0 + (mass - 10.0) * camera_zoom_mass_factor)
	target_zoom = max(target_zoom, camera_zoom_min)

	var zoom_target = Vector2(target_zoom, target_zoom)
	camera.zoom = camera.zoom.lerp(zoom_target, clamp(camera_zoom_smoothing * delta, 0.0, 1.0))
