extends CanvasLayer


func _ready() -> void:
	%Results.text = ""
	for level in G.review:
		var wrongs = []
		for w in G.review[level]["wrong"]:
			wrongs.append(G.cns[w])
		%Results.text += "Laptop " + str(level) + ":" + str(G.review[level]["correct"].size()) + "/4 expansion cards correct [color=red](" + ", ".join(wrongs) + ")[/color]\n"


func _on_play_again_pressed() -> void:
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Fade.fade_in()
