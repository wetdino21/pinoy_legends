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

@onready var body = $Body
@onready var head = $Head

func _ready():
    time_until_detach = detach_interval
    head.position = body.position
    player = get_tree().get_first_node_in_group("player")

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
