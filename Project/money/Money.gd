extends Spatial



func _on_Area_body_entered(body):
	if body.name == "character":
		Global.gamepoint += 20
		queue_free()
