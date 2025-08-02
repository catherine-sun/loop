extends MarginContainer

enum ControlGroup {
  UPDOWN,
  LMB
}
@export var updown: BoxContainer
@export var lmb: BoxContainer

func show_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.show()
		ControlGroup.LMB:
			lmb.show()

func hide_control_group(group: ControlGroup) -> void:
	match group:
		ControlGroup.UPDOWN:
			updown.hide()
		ControlGroup.LMB:
			lmb.hide()
