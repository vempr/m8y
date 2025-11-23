extends Node

var positions := {
	G.SLOT.TOP_LEFT: null,
	G.SLOT.BOTTOM_LEFT: null,
	G.SLOT.TOP_RIGHT: null,
	G.SLOT.BOTTOM_RIGHT: null,
}


func reset() -> void:
	positions = {
		G.SLOT.TOP_LEFT: null,
		G.SLOT.BOTTOM_LEFT: null,
		G.SLOT.TOP_RIGHT: null,
		G.SLOT.BOTTOM_RIGHT: null,
	}
