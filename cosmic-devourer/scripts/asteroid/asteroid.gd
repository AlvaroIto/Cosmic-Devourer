extends Area2D

@export var mass: float = 1.0
@export var radius: float = 8.0
@export var asteroid_size: int = 1
@export var gravity_force: float = 100.0

var player: Node2D


func _ready():
	setup_by_size()
	queue_redraw()
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	
	var gravity_range = player.gravity_range_base + (player.mass - 10.0) * player.gravity_range_per_mass

	if distance < gravity_range:
		var direction = global_position.direction_to(player.global_position)
		var force = gravity_force * (player.mass / 10.0)

		global_position += direction * force * delta

func setup_by_size():
	match asteroid_size:
		1:
			mass = 1.0
			radius = 8.0

		2:
			mass = 5.0
			radius = 15.0

		3:
			mass = 15.0
			radius = 25.0

		4:
			mass = 40.0
			radius = 40.0

func _draw():
	draw_circle(Vector2.ZERO, radius, Color(0.45, 0.45, 0.45))
	draw_circle(Vector2(-2, -2), radius * 0.25, Color(0.30, 0.30, 0.30))


func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.player_size >= asteroid_size:
			body.collect_mass(mass)
			get_parent().asteroid_collected()
			queue_free()
