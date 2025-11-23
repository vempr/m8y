extends Control

enum CARD { USB_C, USB_A, HDMI, ETHERNET, DISPLAY_PORT, MICRO_SD, SD, STORAGE }
@export var card := CARD.USB_C


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print("kaboom")
