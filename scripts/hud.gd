extends CanvasLayer

signal dispatch_card(card: G.CARD, pos: G.SLOT)
signal remove_card(pos: G.SLOT)

var card = null


func _ready() -> void:
	%ExpansionCards.visible = false
	%Choices.visible = false
	%Labels.visible = false
	%Remove.visible = false


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


func _on_game_update_hud() -> void:
	%Labels.visible = true
	%TopLeftLabel.visible = false
	%BottomLeftLabel.visible = false
	%TopRightLabel.visible = false
	%BottomRightLabel.visible = false
	%Remove.visible = true
	%TopLeftRemove.visible = false
	%BottomLeftRemove.visible = false
	%TopRightRemove.visible = false
	%BottomRightRemove.visible = false
	
	var tl = S.positions[G.SLOT.TOP_LEFT]
	var bl = S.positions[G.SLOT.BOTTOM_LEFT]
	var tor = S.positions[G.SLOT.TOP_RIGHT]
	var br = S.positions[G.SLOT.BOTTOM_RIGHT]
	
	if tl != null:
		%TopLeftLabel.visible = true
		%TopLeftLabel.text = G.cns[tl]
		%TopLeftRemove.visible = true
	if bl != null:
		%BottomLeftLabel.visible = true
		%BottomLeftLabel.text = G.cns[bl]
		%BottomLeftRemove.visible = true
	if tor != null:
		%TopRightLabel.visible = true
		%TopRightLabel.text = G.cns[tor]
		%TopRightRemove.visible = true
	if br != null:
		%BottomRightLabel.visible = true
		%BottomRightLabel.text = G.cns[br]
		%BottomRightRemove.visible = true


func _on_top_left_remove_pressed() -> void:
	%TopLeftLabel.visible = false
	%TopLeftRemove.visible = false
	%TopLeftButton.visible = true
	remove_card.emit(G.SLOT.TOP_LEFT)


func _on_bottom_left_remove_pressed() -> void:
	%BottomLeftLabel.visible = false
	%BottomLeftRemove.visible = false
	%BottomLeftButton.visible = true
	remove_card.emit(G.SLOT.BOTTOM_LEFT)


func _on_top_right_remove_pressed() -> void:
	%TopRightLabel.visible = false
	%TopRightRemove.visible = false
	%TopRightButton.visible = true
	remove_card.emit(G.SLOT.TOP_RIGHT)


func _on_bottom_right_remove_pressed() -> void:
	%BottomRightLabel.visible = false
	%BottomRightRemove.visible = false
	%BottomRightButton.visible = true
	remove_card.emit(G.SLOT.BOTTOM_RIGHT)
