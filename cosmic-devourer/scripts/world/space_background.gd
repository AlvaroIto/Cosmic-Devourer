extends Parallax2D

@export var tile_size: float = 512.0
@export var star_count: int = 100

func _ready():
	repeat_size = Vector2(tile_size, tile_size)
	queue_redraw()

func _draw():
	var rng = RandomNumberGenerator.new()
	rng.seed = 12345

	for i in range(star_count):
		var pos = Vector2(
			rng.randf_range(0.0, tile_size),
			rng.randf_range(0.0, tile_size)
		)

		var radius = rng.randf_range(0.7, 1.8)
		var brightness = rng.randf_range(0.35, 0.9)

		draw_circle(
			pos,
			radius,
			Color(brightness, brightness, brightness, 1.0)
		)
