extends MarginContainer

enum ControlGroup {
	UPDOWN,
	LMB,
	LOCK
}
@export var updown: BoxContainer
@export var lmb: BoxContainer
@export var lock: BoxContainer

func show_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.show()
		ControlGroup.LMB:
			lmb.show()
		ControlGroup.LOCK:
			lock.show()

func hide_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.hide()
		ControlGroup.LMB:
			lmb.hide()
		ControlGroup.LOCK:
			lock.hide()
