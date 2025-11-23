extends Node3D

enum CARD { USB_C, USB_A, HDMI, ETHERNET, DISPLAY_PORT, MICRO_SD, SD, STORAGE }
@export var card := CARD.USB_C


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
