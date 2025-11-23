extends CanvasLayer

signal dispatch_card(card: G.CARD, pos: G.SLOT)

var card = null


func _ready() -> void:
	%ExpansionCards.visible = false
	%Choices.visible = false


func _on_expansion_card_btn_dispatch(c: int) -> void:
	%Choices.visible = true
	card = c


func _on_game_toggle_hud(v: bool) -> void:
	if v:
		%ExpansionCards.visible = true


func _on_top_left_button_pressed() -> void:
	%Choices.visible = false
	%TopLeftButton.visible = false
	dispatch_card.emit(card, G.SLOT.TOP_LEFT)


func _on_bottom_left_button_pressed() -> void:
	%Choices.visible = false
	%BottomLeftButton.visible = false
	dispatch_card.emit(card, G.SLOT.BOTTOM_LEFT)


func _on_top_right_button_pressed() -> void:
	%Choices.visible = false
	%TopRightButton.visible = false
	dispatch_card.emit(card, G.SLOT.TOP_RIGHT)


func _on_bottom_right_button_pressed() -> void:
	%Choices.visible = false
	%BottomRightButton.visible = false
	dispatch_card.emit(card, G.SLOT.BOTTOM_RIGHT)
