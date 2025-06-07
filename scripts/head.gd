extends CharacterBody2D    
class_name Head

var blood_timer := 0.0
var blood_interval := 0.1
var delay_buffer := []  # Stores old positions
var blood_delay_time := 0.5  # Delay in seconds

@onready var blood_particles = $BloodParticles
@onready var blood_stain_scene = preload("res://scenes/blood_stain.tscn")

func _ready():
    if blood_particles:
        blood_particles.emitting = false

func _process(delta: float) -> void:
        var state_name = get_enemy_state()
        match state_name:
            "head_chase":
                if blood_particles:
                    blood_particles.global_position = global_position
                    blood_particles.emitting = true
                    
                    #blood stain
                    blood_timer -= delta

                    # Store head position for delay effect
                    delay_buffer.append(global_position)
                    
                    # Remove old positions
                    var max_buffer_size = int(blood_delay_time / delta)
                    if delay_buffer.size() > max_buffer_size:
                        delay_buffer.pop_front()

                    if blood_timer <= 0.0 and delay_buffer.size() >= max_buffer_size:
                        blood_timer = blood_interval
                        spawn_blood_trail()
                    else:
                        if blood_particles:
                            blood_particles.emitting = false
            _:
                blood_particles.emitting = false 
                  
func _physics_process(delta):
    move_and_slide()
  
func get_enemy_state() -> String:
    var enemy = get_parent()
    if enemy and enemy.has_node("StateMachine"):
        var sm = enemy.get_node("StateMachine")
        if sm.has_method("get_current_state_name"):
            return sm.get_current_state_name()
    return ""

func spawn_blood_trail():
    var base_position = delay_buffer[0]
    base_position.y += 20  # Drop offset to simulate falling from head

    for i in range(3):
        var blood = blood_stain_scene.instantiate()

        # Slight random offset around the base position
        var offset = Vector2(
            randf_range(-10, 10),
            randf_range(-4, 4)
        )
        blood.global_position = base_position + offset

        blood.rotation = randf_range(0.0, TAU)
        blood.scale = Vector2.ONE * randf_range(0.05, 0.1)

        get_tree().current_scene.add_child(blood)
          
#extends CharacterBody2D
#
#@export var chase_speed := 100.0
#@export var return_speed := 80.0
#var wander_direction := Vector2.ZERO
#var wander_timer := 0.0
#
#func chase_player(player_pos: Vector2):
    #var direction = (player_pos - global_position).normalized()
    #velocity = direction * chase_speed
    #move_and_slide()
    ##pass
#
#func return_to_body(body_pos: Vector2) -> bool:
    #var to_body = (body_pos - global_position)
    #var distance = to_body.length()
    #
    ## Increase return speed when very close to prevent getting stuck
    #var current_speed = return_speed
    #if distance < 20.0:
        #current_speed *= 2.0  # Double speed when close
    #
    #velocity = to_body.normalized() * current_speed
    #move_and_slide()
    #
    ## More lenient reattachment distance
    #return distance < 5.0
#
#func idle(delta):
    #wander_timer -= delta
    #if wander_timer <= 0:
        ## Pick a new random direction every 1-2 seconds
        #wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
        #wander_timer = randf_range(1.0, 2.0)
#
    #velocity = wander_direction * 20.0  # You can adjust wander speed here
    #move_and_slide()
