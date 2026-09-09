extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(_delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
		"ui_down"
	)

	velocity = direction * speed
	move_and_slide()

func _draw():
	draw_circle(Vector2.ZERO, 30.0, Color(0.35, 0.35, 0.35))
	draw_circle(Vector2(-10, -8), 5.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(9, 5), 7.0, Color(0.22, 0.22, 0.22))
	draw_circle(Vector2(3, -13), 3.0, Color(0.18, 0.18, 0.18))
