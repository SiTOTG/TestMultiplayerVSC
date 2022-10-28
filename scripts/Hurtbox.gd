class_name Hurtbox
extends Area2D

signal take_damage(damage)

func apply_damage(damage: int):
	take_damage.emit(damage)
