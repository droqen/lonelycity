extends Node2D

var vel : Vector2

func _physics_process(_delta: float) -> void:
	var target = get_global_mouse_position()
	var totarget = target-position
	var totarget_reduced = totarget.normalized() * maxf(0,totarget.length()-5)
	vel = (totarget_reduced * 0.05).limit_length(5.0)
	position += vel
	queue_redraw()

func _draw() -> void:
	var xform : Transform2D = (Transform2D.IDENTITY
		.scaled(Vector2(1+0.20*vel.length(),1-0.05*vel.length()))
		.rotated(vel.angle())
	)
	draw_set_transform_matrix(xform)
	draw_rect(Rect2(-3,-3,6,6), Color.WHITE, true)
	#draw_set_transform_matrix(Transform2D.IDENTITY)
	#draw_rect(Rect2(-1,-1,2,2), Color.BLACK, true)
	#
	#if vel.length():
		#rotation = vel.angle()
	#scale.x = 1 + 0.20 * vel.length()
	#scale.y = 1 - 0.05 * vel.length()
