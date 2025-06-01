extends CharacterBody2D

@export var speed := 50.0
var is_detached := false
var wander_direction := Vector2.ZERO
var wander_timer := 0.0

func chase_player(player_pos: Vector2):
    if !is_detached:
        var direction = (player_pos - global_position).normalized()
        velocity = direction * speed
        move_and_slide()

func stop_moving():
    velocity = Vector2.ZERO
    move_and_slide()
    
func idle(delta):
    wander_timer -= delta
    if wander_timer <= 0:
        # Pick a new random direction every 1-2 seconds
        wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
        wander_timer = randf_range(1.0, 2.0)

    velocity = wander_direction * 20.0  # You can adjust wander speed here
    move_and_slide()
