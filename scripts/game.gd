extends Node3D

const ZOOMED_IN_FOV := 45.0
const ZOOM_SPEED := 3.0

var animation_in_progress := false
var start := false


func _ready() -> void:
	%Framework.visible = false
	%Box.visible = false
	await start_sequence()
	


func start_sequence() -> bool:
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

	await get_tree().create_timer(0.4).timeout
	animation_in_progress = false
	start = true
	return true


func end_sequence() -> void:
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
	await get_tree().create_timer(1.0).timeout
	# start_sequence()


func _process(delta: float) -> void:
	if start:
		%Camera.fov = lerp(%Camera.fov, ZOOMED_IN_FOV, ZOOM_SPEED * delta)
		if %Camera.fov == ZOOMED_IN_FOV:
			start = false


func _on_box_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass


func _on_framework_animation_player_animation_finished(_anim_name: StringName) -> void:
	pass
