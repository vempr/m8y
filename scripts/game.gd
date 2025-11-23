extends Node3D

signal toggle_hud(is_visible: bool)
signal update_hud
signal reveal_hud
signal inform_hud

@onready var ExCDisplayPort := preload("res://scenes/expansion_cards/usb_a_hdmi_dp_expansion_card.tscn")
@onready var ExCEthernet := preload("res://scenes/expansion_cards/ethernet_expansion_card.tscn")
@onready var ExCHDMI := preload("res://scenes/expansion_cards/usb_a_hdmi_dp_expansion_card.tscn")
@onready var ExCMicroSD := preload("res://scenes/expansion_cards/micro_sd_expansion_card.tscn")
@onready var ExCSD := preload("res://scenes/expansion_cards/sd_expansion_card.tscn")
@onready var ExCStorage := preload("res://scenes/expansion_cards/storage_expansion_card.tscn")
@onready var ExCUsbA := preload("res://scenes/expansion_cards/usb_a_hdmi_dp_expansion_card.tscn")
@onready var ExCUsbC := preload("res://scenes/expansion_cards/usb_c_expansion_card.tscn")

const ZOOMED_OUT_FOV := 75.0
const ZOOMED_IN_FOV := 45.0
const ZOOM_SPEED := 3.0

var animation_in_progress := false
var start := false
var end := false
var cards := {
	G.SLOT.TOP_LEFT: [],
	G.SLOT.BOTTOM_LEFT: [],
	G.SLOT.TOP_RIGHT: [],
	G.SLOT.BOTTOM_RIGHT: [],
}


func _ready() -> void:
	G.reset()
	S.reset()
	
	%Camera.fov = ZOOMED_OUT_FOV
	%Framework.visible = false
	%Box.visible = false
	await start_sequence()
	toggle_hud.emit(true)


func start_sequence() -> bool:
	for child in %TopLeft.get_children():
		child.visible = false
	for child in %BottomLeft.get_children():
		child.visible = false
	for child in %TopRight.get_children():
		child.visible = false
	for child in %BottomRight.get_children():
		child.visible = false
	
	new_request()
	
	if animation_in_progress:
		return false
	animation_in_progress = true
	
	%BoxAnimationPlayer.stop()
	%FrameworkAnimationPlayer.stop()
	
	%BoxAnimationPlayer.play("RESET")
	%FrameworkAnimationPlayer.play("RESET")
	await get_tree().create_timer(0.1).timeout
	
	%Box.visible = true
	%BoxAnimationPlayer.play("move_backwards")
	await %BoxAnimationPlayer.animation_finished
	%Framework.visible = true
	
	%BoxAnimationPlayer.play("open")
	await %BoxAnimationPlayer.animation_finished
	
	%FrameworkAnimationPlayer.play("hover")
	await %FrameworkAnimationPlayer.animation_finished
	
	%BoxAnimationPlayer.play("move")
	await %BoxAnimationPlayer.animation_finished
	
	%FrameworkAnimationPlayer.play("hover_backwards")
	await %FrameworkAnimationPlayer.animation_finished

	animation_in_progress = false
	start = true
	return true


func end_sequence() -> bool:
	%FrameworkAnimationPlayer.play("flip")
	await %FrameworkAnimationPlayer.animation_finished
	
	%FrameworkAnimationPlayer.play("hover")
	await %FrameworkAnimationPlayer.animation_finished
	
	%BoxAnimationPlayer.play("move_backwards")
	await %BoxAnimationPlayer.animation_finished
	
	%FrameworkAnimationPlayer.play("hover_backwards")
	await %FrameworkAnimationPlayer.animation_finished
	
	%BoxAnimationPlayer.play("open_backwards")
	await %BoxAnimationPlayer.animation_finished

	%Framework.visible = false
	%BoxAnimationPlayer.play("move")
	await %BoxAnimationPlayer.animation_finished
	%Box.visible = false

	animation_in_progress = false
	return true


func _process(delta: float) -> void:
	if start:
		%Camera.fov = lerp(%Camera.fov, ZOOMED_IN_FOV, ZOOM_SPEED * delta)
		if %Camera.fov <= ZOOMED_IN_FOV + 0.01:
			%Camera.fov = ZOOMED_IN_FOV
			start = false
	if end:
		%Camera.fov = lerp(%Camera.fov, ZOOMED_OUT_FOV, ZOOM_SPEED * delta)
		if %Camera.fov <= ZOOMED_OUT_FOV + 0.01:
			%Camera.fov = ZOOMED_OUT_FOV
			end = false


func _on_box_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass


func _on_framework_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["flip_left_reverse", "flip_right", "flip_right_reverse", "flip_left"]:
		reveal_hud.emit()


func _on_hud_dispatch_card(card: int, pos: int) -> void:
	if %ECAnimationPlayer.is_playing():
		return
	
	print(card, "@", pos)
	var expc
	
	match card:
		G.CARD.USB_C:
			expc = ExCUsbC.instantiate()
		G.CARD.USB_A:
			expc = ExCUsbA.instantiate()
		G.CARD.HDMI:
			expc = ExCHDMI.instantiate()
		G.CARD.ETHERNET:
			expc = ExCEthernet.instantiate()
		G.CARD.DISPLAY_PORT:
			expc = ExCDisplayPort.instantiate()
		G.CARD.MICRO_SD:
			expc = ExCMicroSD.instantiate()
		G.CARD.SD:
			expc = ExCSD.instantiate()
		G.CARD.STORAGE:
			expc = ExCStorage.instantiate()
	
	var cn: String = G.card_names[card]
	match pos:
		G.SLOT.TOP_LEFT:
			S.positions[G.SLOT.TOP_LEFT] = card
			%ECAnimationPlayer.play("top_left_in")
			
			if cn not in cards[G.SLOT.TOP_LEFT]:
				cards[G.SLOT.TOP_LEFT].append(cn)
				for child in %TopLeft.get_children():
					child.visible = false
				%TopLeft.add_child(expc)
			else:
				for child in %TopLeft.get_children():
					child.visible = false
				%TopLeft.get_node(cn).visible = true
				
		G.SLOT.BOTTOM_LEFT:
			S.positions[G.SLOT.BOTTOM_LEFT] = card
			%ECAnimationPlayer.play("bottom_left_in")
			
			if cn not in cards[G.SLOT.BOTTOM_LEFT]:
				cards[G.SLOT.BOTTOM_LEFT].append(cn)
				for child in %BottomLeft.get_children():
					child.visible = false
				%BottomLeft.add_child(expc)
			else:
				for child in %BottomLeft.get_children():
					child.visible = false
				%BottomLeft.get_node(cn).visible = true
				
		G.SLOT.TOP_RIGHT:
			S.positions[G.SLOT.TOP_RIGHT] = card
			%ECAnimationPlayer.play("top_right_in")
			
			if cn not in cards[G.SLOT.TOP_RIGHT]:
				cards[G.SLOT.TOP_RIGHT].append(cn)
				for child in %TopRight.get_children():
					child.visible = false
				%TopRight.add_child(expc)
			else:
				for child in %TopRight.get_children():
					child.visible = false
				%TopRight.get_node(cn).visible = true
				
		G.SLOT.BOTTOM_RIGHT:
			S.positions[G.SLOT.BOTTOM_RIGHT] = card
			%ECAnimationPlayer.play("bottom_right_in")
			
			if cn not in cards[G.SLOT.BOTTOM_RIGHT]:
				cards[G.SLOT.BOTTOM_RIGHT].append(cn)
				for child in %BottomRight.get_children():
					child.visible = false
				%BottomRight.add_child(expc)
			else:
				for child in %BottomRight.get_children():
					child.visible = false
				%BottomRight.get_node(cn).visible = true


func _on_ec_animation_player_animation_finished(_anim_name: StringName) -> void:
	update_hud.emit()


func _on_hud_remove_card(pos: int) -> void:
	if %ECAnimationPlayer.is_playing():
		return
	
	print("-", pos)
	
	match pos:
		G.SLOT.TOP_LEFT:
			S.positions[G.SLOT.TOP_LEFT] = null
			%ECAnimationPlayer.play("top_left_out")
		G.SLOT.BOTTOM_LEFT:
			S.positions[G.SLOT.BOTTOM_LEFT] = null
			%ECAnimationPlayer.play("bottom_left_out")
		G.SLOT.TOP_RIGHT:
			S.positions[G.SLOT.TOP_RIGHT] = null
			%ECAnimationPlayer.play("top_right_out")
		G.SLOT.BOTTOM_RIGHT:
			S.positions[G.SLOT.BOTTOM_RIGHT] = null
			%ECAnimationPlayer.play("bottom_right_out")


func _on_hud_animate(from: int, to: int) -> void:
	if from == -1 && to == 0:
		%FrameworkAnimationPlayer.play("flip_left_reverse")
	elif from == 0 && to == 1:
		%FrameworkAnimationPlayer.play("flip_right")
	elif from == 1 && to == 0:
		%FrameworkAnimationPlayer.play("flip_right_reverse")
	elif from == 0 && to == -1:
		%FrameworkAnimationPlayer.play("flip_left")


func _on_hud_ship() -> void:
	review()
	
	end = true
	G.level += 1
	
	await end_sequence()
	if G.level <= 10:
		await start_sequence()
		toggle_hud.emit(true)
	else:
		await Fade.fade_out().finished
		get_tree().change_scene_to_file("res://scenes/end.tscn")
		Fade.fade_in()


func new_request() -> void:
	S.reset()
	var ri := randi_range(0, G.messages.size() - 1)
	G.request = G.messages[ri]
	G.messages.remove_at(ri)
	inform_hud.emit()


func review() -> void:
	G.review[G.level]["message"] = G.request
	var remaining_correct_cards = G.request["correct"].duplicate()
	
	for pos in S.positions:
		var card = S.positions[pos]
		var card_i = remaining_correct_cards.find(card)
		
		if card_i != -1:
			remaining_correct_cards.remove_at(card_i)
			G.review[G.level]["correct"].append(card)
		else:
			G.review[G.level]["wrong"].append(card)
