extends CharacterBody2D

@export var mass: float = 10.0
@export var radius: float = 30.0
@export var speed: float = 100.0
var direction: Vector2 = Vector2.ZERO

func _ready():
	update_from_mass()
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
	velocity = direction * speed
	move_and_slide()
