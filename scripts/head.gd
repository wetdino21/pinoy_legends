extends CharacterBody2D

@export var chase_speed := 100.0
@export var return_speed := 80.0
var wander_direction := Vector2.ZERO
var wander_timer := 0.0

func chase_player(player_pos: Vector2):
    var direction = (player_pos - global_position).normalized()
    velocity = direction * chase_speed
    move_and_slide()
    #pass

func return_to_body(body_pos: Vector2) -> bool:
    var to_body = (body_pos - global_position)
    var distance = to_body.length()
    
    # Increase return speed when very close to prevent getting stuck
    var current_speed = return_speed
    if distance < 20.0:
        current_speed *= 2.0  # Double speed when close
    
    velocity = to_body.normalized() * current_speed
    move_and_slide()
    
    # More lenient reattachment distance
    return distance < 5.0

func idle(delta):
    wander_timer -= delta
    if wander_timer <= 0:
        # Pick a new random direction every 1-2 seconds
        wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
        wander_timer = randf_range(1.0, 2.0)

    velocity = wander_direction * 20.0  # You can adjust wander speed here
    move_and_slide()
