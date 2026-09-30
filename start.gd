extends Button

var to_game = preload("res://game_.tscn")

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(to_game)
