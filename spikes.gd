extends Area2D


func on_Spikes_body_entered(body):
	if body is Player: 
		# reload world
		get_tree().reload_current_scene()
		# removes body that stepped on it
		#body.queue_free()
