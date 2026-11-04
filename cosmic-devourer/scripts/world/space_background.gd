extends Node2D

@export var tile_size: Vector2 = Vector2(1920, 1080)
@export var star_count: int = 500

func _ready():
	queue_redraw()

func _draw():
	var rng = RandomNumberGenerator.new()
	rng.seed = 12345

	for i in range(star_count):
		var pos = Vector2(
			rng.randf_range(0.0, tile_size.x),
			rng.randf_range(0.0, tile_size.y)
		)

		var radius = rng.randf_range(0.7, 1.8)
		var brightness = rng.randf_range(0.15, 0.4)

		draw_circle(
			pos,
			radius,
			Color(brightness, brightness, brightness, 1.0)
		)
