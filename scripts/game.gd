extends Node3D

enum BOX_STATE { OPENING, HOVERING, MOVING, CLOSING }
enum BOX_SEQUENCE { OPEN, CLOSE }
var box_state := BOX_STATE.OPENING
var is_open := false
var sequence := BOX_SEQUENCE.OPEN


func _ready() -> void:
	%Framework.visible = false
	%Box.visible = true
	
	%BoxAnimationPlayer.play("RESET")
	%FrameworkAnimationPlayer.play("RESET")
	
	demo()


func demo() -> void:
	%Framework.visible = false
	
	%BoxAnimationPlayer.play("move_backwards")
	await get_tree().create_timer(2).timeout
	
	%Framework.visible = true
	
	open_box()
	await get_tree().create_timer(5).timeout
	close_box()
	await get_tree().create_timer(3).timeout
	
	%Framework.visible = false
	%BoxAnimationPlayer.play("move")


func open_box() -> void:
	sequence = BOX_SEQUENCE.OPEN
	
	%BoxAnimationPlayer.play("RESET")
	%FrameworkAnimationPlayer.play("RESET")
	%BoxAnimationPlayer.play("open")


func close_box() -> void:
	sequence = BOX_SEQUENCE.CLOSE
	%FrameworkAnimationPlayer.play("flip")


func _process(_delta: float) -> void:
	pass


func _on_box_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"open":
			is_open = true
			box_state = BOX_STATE.HOVERING
			%FrameworkAnimationPlayer.play("hover")
		"move":
			%FrameworkAnimationPlayer.play("hover_backwards")
		"move_backwards":
			%FrameworkAnimationPlayer.play("hover_backwards")
		"open_backwards":
			is_open = false
			box_state = BOX_STATE.OPENING


func _on_framework_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"flip":
			%FrameworkAnimationPlayer.play("hover")
		"hover":
			if sequence == BOX_SEQUENCE.OPEN:
				%BoxAnimationPlayer.play("move")
			elif sequence == BOX_SEQUENCE.CLOSE:
				%BoxAnimationPlayer.play("move_backwards")
		"hover_backwards":
			if sequence == BOX_SEQUENCE.OPEN:
				return
			elif sequence == BOX_SEQUENCE.CLOSE:
				%BoxAnimationPlayer.play("open_backwards")
