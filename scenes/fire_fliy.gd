extends Node2D

@export var lifetime := 10.0
@export var min_scale := 0.2
@export var max_scale := 0.5

@export var min_energy := 0.7
@export var max_energy := 1.0

@export var move_radius := 50.0
@export var move_speed := 10

var base_position: Vector2
var final_scale: float
var final_energy: float

var t := 0.0
var offset_x := randf_range(0.0, TAU)
var offset_y := randf_range(0.0, TAU)
var move_timer := 0.0
var move_duration := 1.5  # how long to stay in one direction
var current_dir := Vector2.ZERO
var velocity := Vector2.ZERO

func _ready():
    # Pick random scale and light energy
    final_scale = randf_range(min_scale, max_scale)
    final_energy = randf_range(min_energy, max_energy)

    base_position = position
    scale = Vector2.ZERO
    $PointLight2D.energy = 0.0
    $Sprite2D.modulate.a = 0.0

    var tween = get_tree().create_tween()
    
    # Fade and scale in
    tween.tween_property(self, "scale", Vector2.ONE * final_scale, lifetime * 0.2).set_trans(Tween.TRANS_SINE)
    tween.parallel().tween_property($Sprite2D, "modulate:a", 1.0, lifetime * 0.2)
    tween.parallel().tween_property($PointLight2D, "energy", final_energy, lifetime * 0.2)

    # Wait (float time)
    tween.tween_interval(lifetime * 0.4)

    # Fade and scale out
    tween.tween_property(self, "scale", Vector2.ZERO, lifetime * 0.4).set_trans(Tween.TRANS_SINE)
    tween.parallel().tween_property($Sprite2D, "modulate:a", 0.0, lifetime * 0.4)
    tween.parallel().tween_property($PointLight2D, "energy", 0.0, lifetime * 0.4)

    tween.connect("finished", Callable(self, "queue_free"))

func _process(delta):
    t += delta
    move_timer -= delta

    # Pick a new random direction every few seconds
    if move_timer <= 0:
        current_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
        move_timer = randf_range(1.5, move_duration)  # stays a bit longer in each direction

    # Consistent speed in current direction
    velocity = current_dir * move_speed
    position += velocity * delta
