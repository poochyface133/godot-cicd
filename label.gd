extends Label

var score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_text("".join(PackedStringArray(["SCORE: ", score])))
	pass

func _on_crowcollectbox_body_entered(body: Node2D) -> void:
	score += 1
