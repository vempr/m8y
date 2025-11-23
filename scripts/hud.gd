extends CanvasLayer

signal dispatch_card(card: G.CARD, pos: G.SLOT)
signal remove_card(pos: G.SLOT)
signal animate(from: int, to: int)
signal ship

var card = null
var perspective := 0


func _ready() -> void:
	%ExpansionCards.visible = false
	%Choices.visible = false
	%Labels.visible = false
	%Remove.visible = false
	%View.visible = false
	
	%TopLeftButton.visible = false
	%BottomLeftButton.visible = false
	%TopRightButton.visible = false
	%BottomRightButton.visible = false
	
	%TopLeftRemove.visible = false
	%BottomLeftRemove.visible = false
	%TopRightRemove.visible = false
	%BottomRightRemove.visible = false
	
	%Ship.disabled = true


func _on_expansion_card_btn_dispatch(c: int) -> void:
	%Choices.visible = true
	card = c
	
	if S.positions[G.SLOT.TOP_LEFT] == null:
		%TopLeftButton.visible = true
	else:
		%TopLeftButton.visible = false
		
	if S.positions[G.SLOT.BOTTOM_LEFT] == null:
		%BottomLeftButton.visible = true
	else:
		%BottomLeftButton.visible = false
	
	if S.positions[G.SLOT.TOP_RIGHT] == null:
		%TopRightButton.visible = true
	else:
		%TopRightButton.visible = false
	
	if S.positions[G.SLOT.BOTTOM_RIGHT] == null:
		%BottomRightButton.visible = true
	else:
		%BottomRightButton.visible = false


func _on_game_toggle_hud(v: bool) -> void:
	if v:
		%ExpansionCards.visible = true
		%View.visible = true


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
	
	if tl != null && bl != null && tor != null && br != null:
		%Ship.disabled = false


func _on_top_left_remove_pressed() -> void:
	%Ship.disabled = true
	%TopLeftLabel.visible = false
	%TopLeftRemove.visible = false
	remove_card.emit(G.SLOT.TOP_LEFT)


func _on_bottom_left_remove_pressed() -> void:
	%Ship.disabled = true
	%BottomLeftLabel.visible = false
	%BottomLeftRemove.visible = false
	remove_card.emit(G.SLOT.BOTTOM_LEFT)


func _on_top_right_remove_pressed() -> void:
	%Ship.disabled = true
	%TopRightLabel.visible = false
	%TopRightRemove.visible = false
	remove_card.emit(G.SLOT.TOP_RIGHT)


func _on_bottom_right_remove_pressed() -> void:
	%Ship.disabled = true
	%BottomRightLabel.visible = false
	%BottomRightRemove.visible = false
	remove_card.emit(G.SLOT.BOTTOM_RIGHT)


func _on_left_pressed() -> void:
	%Ship.disabled = true
	hi(false)
	hide_all_slots()
	%Right.visible = true
	
	var np := perspective - 1
	if np == -1:
		%Left.visible = false
	
	animate.emit(perspective, np)
	perspective = np


func _on_right_pressed() -> void:
	%Ship.disabled = true
	hi(false)
	hide_all_slots()
	%Left.visible = true
	
	var np := perspective + 1
	if np:
		%Right.visible = false
	
	animate.emit(perspective, np)
	perspective = np


func _on_game_reveal_hud() -> void:
	if perspective == 0:
		var tl = S.positions[G.SLOT.TOP_LEFT]
		var bl = S.positions[G.SLOT.BOTTOM_LEFT]
		var tor = S.positions[G.SLOT.TOP_RIGHT]
		var br = S.positions[G.SLOT.BOTTOM_RIGHT]
		if tl != null && bl != null && tor != null && br != null:
			%Ship.disabled = false
		
		hi(true)
		_on_game_update_hud()
	else:
		%View.visible = true


func hi(vis: bool) -> void:
	%ExpansionCards.visible = vis
	%View.visible = vis
	%Choices.visible = vis


func _on_ship_pressed() -> void:
	%MouseClick.play(0.15)
	%Ship.disabled = true
	hi(false)
	hide_all_slots()
	ship.emit()


func _on_game_inform_hud() -> void:
	%Choices.visible = false
	
	%Request.text = G.request["message"]
	%Sender.text = G.request["name"]
	%Level.text = "LEVEL // [color=orange]" + str(G.level) +  "[/color] "
	if G.level == 1:
		%History.text = "Previous: 0/0 correct"
	else:
		%History.text = "Previous: " + str(G.review[G.level - 1]["correct"].size()) + "/4 correct"


func hide_all_slots():
	%Labels.visible = false
	%Remove.visible = false

	%TopLeftLabel.visible = false
	%BottomLeftLabel.visible = false
	%TopRightLabel.visible = false
	%BottomRightLabel.visible = false

	%TopLeftRemove.visible = false
	%BottomLeftRemove.visible = false
	%TopRightRemove.visible = false
	%BottomRightRemove.visible = false
