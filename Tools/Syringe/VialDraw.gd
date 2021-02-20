extends Node2D

signal liquid_drawn()

const SyringeScene = preload("res://Tools/Syringe/Syringe.tscn")

var syringe_instance

## Fluid Drawing From Vial
func start_draw_fluid(fluidColor):
	var syringePosition = Vector2.ZERO
	
	match fluidColor:
		Syringe.FluidColor.PINK:
			syringePosition = $PinkVialSyringePos.position
		Syringe.FluidColor.YELLOW:
			syringePosition = $YellowVialSyringePos.position
		Syringe.FluidColor.BLUE:
			syringePosition = $BlueVialSyringPos.position
			
	syringe_instance = SyringeScene.instance()
	add_child(syringe_instance)
	syringe_instance.init_for_liquid_draw(fluidColor, syringePosition)
	syringe_instance.connect("liquid_drawn", self, "_on_liquid_drawn")
	
	syringe_instance.draw_liquid()

func _on_liquid_drawn():
	emit_signal("liquid_drawn")

func end_fluid_draw():
	if syringe_instance != null:
		syringe_instance.queue_free()
		syringe_instance = null

func syringe_in_zone() -> bool:
	return syringe_instance != null && syringe_instance.in_zone()
