extends MarginContainer

enum ControlGroup {
	UPDOWN,
	LMB,
	LOCK,
	UNLOCK
}
@export var updown: BoxContainer
@export var lmb: BoxContainer
@export var lock: BoxContainer
@export var unlock: BoxContainer

func show_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.show()
		ControlGroup.LMB:
			lmb.show()
		ControlGroup.LOCK:
			lock.show()
		ControlGroup.UNLOCK:
			unlock.show()

func hide_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.hide()
		ControlGroup.LMB:
			lmb.hide()
		ControlGroup.LOCK:
			lock.hide()
		ControlGroup.UNLOCK:
			unlock.hide()
