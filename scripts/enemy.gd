extends Node2D

@export var normal_speed := 50.0
@export var head_return_speed := 100.0
@export var detach_interval := 3.0
@export var head_flight_time := 10.0
@export var chase_radius := 100.0

var is_detached := false
var is_returning := false
var time_until_detach := 0.0
var head_return_timer := 0.0
var player: CharacterBody2D
var stuck_timer := 0.0

var blood_timer := 0.0
var blood_interval := 0.1
var delay_buffer := []  # Stores old positions
var blood_delay_time := 0.5  # Delay in seconds

@onready var body = $Body
@onready var head = $Head
@onready var blood_particles = $BloodParticles
@onready var blood_stain_scene = preload("res://scenes/blood_stain.tscn")

func _ready():
    time_until_detach = detach_interval
    head.position = body.position
    player = get_tree().get_first_node_in_group("player")
    if blood_particles:
        blood_particles.emitting = false

func _process(delta: float) -> void:
    if is_detached:
        if blood_particles:
            blood_particles.global_position = head.global_position
            blood_particles.emitting = true
            
        #blood stain
        blood_timer -= delta

        # Store head position for delay effect
        delay_buffer.append(head.global_position)
        
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
            
func _physics_process(delta):
    if is_returning:
        #print("returningggggg")
        pass
    if !player:
        return
        
    if !is_detached:
        body.chase_player(player.global_position)
        head.position = body.position

    # var distance_to_player = body.global_position.distance_to(player.global_position)
    # if !is_detached:
    #     if distance_to_player <= chase_radius:
    #         body.chase_player(player.global_position)
    #     else:
    #         body.idle(delta)
    #     head.position = body.position

    else:
        if !is_returning:
            # # body.stop_moving()
            # if distance_to_player <= chase_radius:
                head.chase_player(player.global_position)
            # else:
            #     head.idle(delta)
            # #_check_head_distance()
        else:
             # Print debug info for return movement
            var distance = head.global_position.distance_to(body.global_position)
            #print("Return distance: ", distance)
            
             # Force reattachment if stuck
            if head.return_to_body(body.global_position):
                _complete_reattachment()
            elif distance < 20.0:
                stuck_timer += delta
                if stuck_timer >= 0.5:
                    #print("Forcing reattach due to stuck head")
                    _complete_reattachment()
            else:
                stuck_timer = 0.0

                    
            # if head.return_to_body(body.global_position):
            #     _complete_reattachment()
    
    _handle_detachment_timer(delta)

#func _check_head_distance():
    #var distance = head.position.distance_to(body.position)

func _handle_detachment_timer(delta):
    if !is_detached:
        time_until_detach -= delta
        if time_until_detach <= 0:
            _detach_head()
    else:
        if !is_returning:
            #print("Head return timer: ", head_return_timer)
            head_return_timer -= delta
            if head_return_timer <= 0:
                is_returning = true

func _detach_head():
    is_detached = true
    is_returning = false
    body.is_detached = true
    head_return_timer = head_flight_time
    #print("Head detached!")

func _complete_reattachment():
    is_detached = false
    is_returning = false
    body.is_detached = false
    time_until_detach = detach_interval
    # Smoothly set final position
    head.global_position = body.global_position
    #print("Head reattached!")
    
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
