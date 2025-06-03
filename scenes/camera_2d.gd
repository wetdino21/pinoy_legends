extends Camera2D

# Shake settings
var shake_amount := 0.0
var shake_duration := 0.0
var shake_timer := 0.0

func _process(delta: float) -> void:
    if shake_timer > 0:
        shake_timer -= delta

        var offset_x = randf_range(-1.0, 1.0) * shake_amount
        var offset_y = randf_range(-1.0, 1.0) * shake_amount
        offset = Vector2(offset_x, offset_y)

        if shake_timer <= 0:
            offset = Vector2.ZERO
    else:
        offset = Vector2.ZERO

func start_shake(amount: float, duration: float) -> void:
    shake_amount = amount
    shake_duration = duration
    shake_timer = duration
