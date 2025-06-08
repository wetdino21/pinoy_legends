extends Area2D

func _ready():
    connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
    if area.is_in_group("enemy_hurtbox"):
        if area.has_method("take_damage"):
            area.take_damage(10)
