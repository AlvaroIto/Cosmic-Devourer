extends Node2D

@export var asteroid_scene: PackedScene
@export var asteroid_count: int = 5

func _ready():
	for i in range(asteroid_count):
		spawn_asteroid()

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()

	var player = get_tree().get_first_node_in_group("player")
	var new_position = Vector2.ZERO

	while true:
		new_position = Vector2(
			randf_range(100.0, 1100.0),
			randf_range(100.0, 600.0)
		)

		if new_position.distance_to(player.position) > 150.0:
			break

	asteroid.position = new_position

	add_child(asteroid)

func asteroid_collected():
	spawn_asteroid()
