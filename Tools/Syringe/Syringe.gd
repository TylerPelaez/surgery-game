extends Node2D
class_name Syringe

signal entered_fill_zone()
signal exited_fill_zone()
signal liquid_drawn()
signal liquid_dispensed()

onready var syringe_zone = $SyringeZone
# For debug drawing
onready var default_syringe_zone_position = $SyringeZone.position

var in_zone = false

enum FluidColor {
	BLUE,
	PINK,
	YELLOW
}

func _ready():
	pass

func init_for_liquid_draw(fluidColor, new_position):
	$AnimationPlayer.stop()
	position = new_position
	
	match fluidColor:
		FluidColor.BLUE:
			$BlueFluid.visible = true
		FluidColor.PINK:
			$PinkFluid.visible = true
		FluidColor.YELLOW:
			$YellowFluid.visible = true
	
	randomize_success_zone()
	$SyringeZone.visible = true

func init_for_liquid_dispensing(fluidColor, new_position):
	$AnimationPlayer.stop()
	position = new_position
	
	match fluidColor:
		FluidColor.BLUE:
			$BlueFluid.visible = true
		FluidColor.PINK:
			$PinkFluid.visible = true
		FluidColor.YELLOW:
			$YellowFluid.visible = true

func randomize_success_zone():
	# Randomize position of the syringe success zone
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var upper_bound = $SyringeZoneUpperBound.position.y
	var lower_bound = $SyringeZoneLowerBound.position.y
	var syringe_zone_y_pos = rng.randi_range(lower_bound, upper_bound)
	syringe_zone.position = Vector2(syringe_zone.position.x , syringe_zone_y_pos)

func draw_liquid():
	$AnimationPlayer.play("DrawLiquid")

func dispense_liquid():
	$AnimationPlayer.play("DispenseLiquid")

func liquid_drawn():
	emit_signal("liquid_drawn")
	
func liquid_dispensed():
	emit_signal("liquid_dispensed")

func _on_Area2D_area_entered(area):
	in_zone = true

func _on_Area2D_area_exited(area):
	in_zone = false

func in_zone() -> bool:
	return in_zone
