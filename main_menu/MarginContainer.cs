using Godot;
using System;

public partial class MarginContainer : Godot.MarginContainer
{
	public override void _Ready()
	{
		int marginValue = 100;
		AddThemeConstantOverride("margin_top", marginValue);
		AddThemeConstantOverride("margin_left", marginValue);
		AddThemeConstantOverride("margin_bottom", marginValue);
		AddThemeConstantOverride("margin_right", marginValue);
	}
}
