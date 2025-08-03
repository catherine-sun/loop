extends RigidBody2D

signal rope_collision
signal rope_collision_exit

var rope_id = ""
var segment_id = -1
var leftFeeder = false
var controls_ui
var lock_icon

var is_in_cross = false
var is_hovered = false
var is_locked = false
var original_gravity_scale = 0.0
var original_linear_damp = 2.0
var original_angular_damp = 8.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	add_to_group("ropePLEASE")

	# Store original physics properties
	original_gravity_scale = gravity_scale
	original_linear_damp = linear_damp
	original_angular_damp = angular_damp

	controls_ui = get_node("/root/Level/Controls")
	controls_ui.hide_control_group(controls_ui.ControlGroup.LOCK)

	lock_icon = get_node("LockIcon")
	if lock_icon:
		lock_icon.set_locked(false)
		lock_icon.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	is_in_cross = rope_id != "" and RopeManager.isInACross(rope_id, self)

	lock_icon.visible = is_locked
	if is_in_cross:
		if is_locked:
			get_node("Area2D/Icon").modulate = Color(1, 0, 0) # Red
		elif is_hovered:
			lock_icon.visible = true
			get_node("Area2D/Icon").modulate = Color(1, 0.5, 0) # Orange
		else:
			get_node("Area2D/Icon").modulate = Color(1, 1, 0) # Yellow
	else:
		get_node("Area2D/Icon").modulate = Color(1, 1, 1) # White

	if is_locked:
			get_node("Area2D/Icon").modulate = Color(1, 0, 0) # Red

func setup_rope_segment(i: String, j: int):
	rope_id = i
	segment_id = j
	$Area2D.z_index = RopeManager.ropes[rope_id]["layer"]
	name = "RopeSegment" + str(j)

func getLeftFeeder():
	return leftFeeder

func setLeftFeeder(v):
	leftFeeder = v

func updateSegmentCollision():
	collision_layer = 4
	collision_mask = 3

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision", body, self) # Replace with function body.


func _on_area_2d_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if "RopeSegment" in body.name:
		RopeManager.emit_signal("rope_collision_exit", body, self) # Replace with function body.


# ==== locking ====

func _on_area_2d_mouse_entered() -> void:
	is_hovered = true
	RopeManager.set_hovered_segment(self)

	if is_in_cross or is_locked:
		if controls_ui:
			controls_ui.show_control_group(controls_ui.ControlGroup.LOCK)


func _on_area_2d_mouse_exited() -> void:
	is_hovered = false
	RopeManager.clear_hovered_segment(self)

	if is_in_cross or is_locked:
		controls_ui.hide_control_group(controls_ui.ControlGroup.LOCK)


func toggle_lock():
	if is_in_cross:
		is_locked = !is_locked
		if lock_icon:
			lock_icon.set_locked(is_locked)

		apply_physics_lock(is_locked)

		print("Segment ", rope_id, ":", segment_id, " lock state: ", "LOCKED" if is_locked else "UNLOCKED")

func apply_physics_lock(locked: bool):
	if locked:
		freeze = true
		freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
		linear_velocity = Vector2.ZERO
		angular_velocity = 0.0
	else:
		freeze = false
		freeze_mode = RigidBody2D.FREEZE_MODE_STATIC

func is_physics_locked() -> bool:
	return freeze and is_locked
