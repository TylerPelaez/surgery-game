extends Control

onready var day_over = $MarginContainer/MarginContainer/VBoxContainer/DayXOver
onready var money_earned = $MarginContainer/MarginContainer/VBoxContainer/MoneyEarned
onready var patients_treated = $MarginContainer/MarginContainer/VBoxContainer/PatientsTreated
onready var patients_untreated = $MarginContainer/MarginContainer/VBoxContainer/PatientsUntreated
onready var operations_botched = $MarginContainer/MarginContainer/VBoxContainer/OperationsBotched
onready var days_remaining = $MarginContainer/MarginContainer/VBoxContainer/DaysRemaining

func set_stats( death_count, treated_count, not_treated_count, money_earned, current_day, days_remaining):
	self.day_over.text = "Day %d Over" % current_day
	self.money_earned.text = "Money Earned: $%d" % money_earned
	self.patients_treated.text = "Patients Treated: %d" % treated_count
	self.patients_untreated.text = "Patients Untreated: %d" % not_treated_count
	self.operations_botched.text = "Operations Botched: %d" % death_count
	self.days_remaining.text = "Days Remaining: %d" % days_remaining
