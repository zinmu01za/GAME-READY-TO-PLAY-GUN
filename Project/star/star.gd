extends Spatial



func _on_Area_body_entered(body):
	if body.name == "character":
		Global.gamepoint1 += 1
		queue_free()
		if Global.gamepoint1 >=5:
			get_tree().change_scene("res://PauseEndgam/PauseEndgame.tscn")

