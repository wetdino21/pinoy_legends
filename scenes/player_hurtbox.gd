extends Area2D

func take_damage(amount):
    get_parent().apply_damage(amount)
