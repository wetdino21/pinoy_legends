extends Sprite2D

@export var fade_time := 0.3
var timer := 0.0

func _ready():
    self.modulate.a = 0.6 # semi-transparent

func _process(delta):
    timer += delta
    self.modulate.a = lerp(0.6, 0.0, timer / fade_time)
    if timer >= fade_time:
        queue_free()
