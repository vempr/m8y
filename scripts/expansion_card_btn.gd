extends Control

signal dispatch(card: G.CARD)

@export var card := G.CARD.USB_C


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	dispatch.emit(card)
