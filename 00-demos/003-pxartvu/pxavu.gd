extends Node2D
var t : float = 0.0
func _physics_process(delta: float) -> void:
	t += delta
	var artsize = $art.get_rect().size
	var vusize = get_viewport().size
	$Camera2D.zoom.x = vusize.x/artsize.x
	$Camera2D.zoom.y = vusize.y/artsize.y
	var camzoom = minf(
		vusize.x/artsize.x,
		vusize.y/artsize.y
	)
	var zoomfraction : float = 0.9 + 0.09 * sin(0.3+t*1.1)
	$Camera2D.zoom.x = camzoom
	$Camera2D.zoom.y = camzoom
	$Camera2D.rotation = sin(t)*0.1
