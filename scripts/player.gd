extends CharacterBody2D

@export var speed := 100.0
@export var dash_speed := 500.0
@export var dash_duration := 0.15
@export var jump_strength := 100.0
@export var gravity := 300.0

var direction := Vector2.ZERO
var last_facing_up := true

var z_velocity := 0.0
var z_position := 0.0
var is_jumping := false
var is_dashing := false
var afterimage_timer = 0.0
var afterimage_interval = 0.05
var dash_timer := 0.0
var dash_direction := Vector2.ZERO
var can_jump := true
var can_dash := true

var health := 100
var is_invincible := false
var invincible_time := 1.0
var invincible_timer := 0.0
var blink_interval := 0.1
var blink_timer := 0.0


@onready var characterSprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var joystick = get_node("/root/world/MobileUI/VirtualJoystick")
@onready var dash_trail = $DashTrail
@onready var scepter = get_node("/root/world/Player/Scepter") 

func _process(delta):
    if is_invincible:
        invincible_timer -= delta
        blink_timer -= delta
        if blink_timer <= 0:
            characterSprite.visible = !characterSprite.visible
            blink_timer = blink_interval

        if invincible_timer <= 0:
            is_invincible = false
            characterSprite.visible = true
            _set_flash_white(false)


    # Smooth follow target offset to the right of player
    if direction != Vector2.ZERO:
        var offset = direction.normalized() * 16  # distance to maintain
        var scepter_target = global_position - offset + Vector2(0, -z_position)
        scepter.global_position = scepter.global_position.lerp(scepter_target, delta * 10.0)
    #else:
        ## When idle, keep last mirrored direction
        #var idle_offset = dash_direction if is_dashing else Vector2.RIGHT
        #var scepter_target = global_position - idle_offset.normalized() * 16 + Vector2(0, -z_position)
        #scepter.global_position = scepter.global_position.lerp(scepter_target, delta * 10.0)
    
    #scepter.rotation = sin(Time.get_ticks_msec() / 200.0) * 0.1
    
    




    if is_dashing:
        afterimage_timer += delta
        if afterimage_timer >= afterimage_interval:
            _spawn_afterimage()
            afterimage_timer = 0.0
    else:
        afterimage_timer = afterimage_interval
        dash_trail.emitting = false

func _physics_process(delta):
    move_and_slide()

   # Jump logic
    if !is_jumping:
        $Shadow.global_scale = Vector2(1, 1)
        if Input.is_action_just_pressed("jump"):
            _start_jump()
            # is_jumping = true
            # z_velocity = jump_strength
            
    if is_jumping:
        $Shadow.global_scale = Vector2(0.8, 0.8)
        z_velocity -= gravity * delta
        z_position += z_velocity * delta

        if z_position <= 0.0:
            #$CollisionShape2D.disabled = false
            z_position = 0.0
            is_jumping = false
            z_velocity = 0.0
            
    # dashing logic
    if is_dashing:
        dash_timer -= delta
        if dash_timer <= 0.0:
            is_dashing = false
            set_glow_enabled(false)
        velocity = dash_direction * dash_speed
    else:
        # Input only works when not dashing
        direction = Vector2.ZERO

        # Use joystick if pressed, otherwise fallback to keyboard
        if joystick and joystick.is_pressed:
            direction = joystick.output
        else:
            if Input.is_action_pressed("right"):
                direction.x += 1
            if Input.is_action_pressed("left"):
                direction.x -= 1
            if Input.is_action_pressed("down"):
                direction.y += 1
            if Input.is_action_pressed("up"):
                direction.y -= 1

        direction = direction.normalized()
        velocity = direction * speed

        if Input.is_action_just_pressed("dash") and direction != Vector2.ZERO:
            _start_dash()
            $Camera2D.start_shake(1.0, 0.15)
            # is_dashing = true
            # dash_timer = dash_duration
            # dash_direction = direction

            
    # Update animation direction
    if direction.y < 0:
        last_facing_up = true
    elif direction.y > 0:
        last_facing_up = false
    
    characterSprite.position.y = -z_position
    play_animation(direction)

func _start_jump():
    is_jumping = true
    z_velocity = jump_strength
    #$CollisionShape2D.disabled = true

func _start_dash():
    is_dashing = true
    set_glow_enabled(true)
    dash_timer = dash_duration
    dash_direction = direction
    dash_trail.emitting = true
    
    # Emit particles in the opposite direction of dash
    if dash_direction != Vector2.ZERO:
        dash_trail.direction = -dash_direction.normalized()
        dash_trail.global_position = global_position + Vector2(0, -z_position)
        
func _spawn_afterimage():
    var afterimage = preload("res://scenes/afterimage.tscn").instantiate()
    var sprite = $AnimatedSprite2D
    afterimage.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
    afterimage.position = global_position + Vector2(0, -z_position)
    afterimage.scale = sprite.scale
    get_parent().add_child(afterimage)

func play_animation(dir: Vector2):
    var anim = get_animation_name(dir)
    characterSprite.play(anim)

func get_animation_name(dir: Vector2) -> String:
    if dir == Vector2.ZERO:
        return "idle_" + ("up" if last_facing_up else "down")

     # Update both sprites with the same animation
    if is_dashing:
        if dir.y > 0 and abs(dir.x) < 0.1:
            return "dash_down"
        elif dir.y < 0 and abs(dir.x) < 0.1:
            return "dash_up"

        if dir.x < 0 :
            return "dash_left"
        elif dir.x > 0 :
            return "dash_right" 
        
    
    if dir.y > 0 and abs(dir.x) < 0.5:
        return "walk_down"
    elif dir.y < 0 and abs(dir.x) < 0.5:
        return "walk_up"
    
    if dir.x < 0 and dir.y != 0:
        return "walk_left_" + ("up" if dir.y < 0 else "down")
    elif dir.x > 0 and dir.y != 0:
        return "walk_right_" + ("up" if dir.y < 0 else "down")
    
    if dir.x < 0 and dir.y == 0:
        return "walk_left_" + ("up" if last_facing_up else "down")
    elif dir.x > 0 and dir.y == 0:
        return "walk_right_" + ("up" if last_facing_up else "down")
    
    return "idle_" + ("up" if last_facing_up else "down")
    
func set_glow_enabled(enabled: bool):
    var mat = characterSprite.material
    if mat and mat is ShaderMaterial:
        mat.set_shader_parameter("enable_glow", enabled)

func die():
    global_position = Vector2(400, 400)
    health = 100
    #visible = false
    #set_process(false)
    #set_physics_process(false)
    #collision_layer = 0
    #collision_mask = 0
    #emit_signal("died")
    #show_game_over_ui()


func apply_damage(amount):
    
    if is_invincible:
        return

    health -= amount
    print("Player HP:", health)
    
    if health <= 0:
        die()
    else:
        $Camera2D.start_shake(3.0, 0.15)
        start_invincibility()
        
        do_hit_stop(0.08)

func start_invincibility():
    $AnimatedSprite2D/SilhouetteSprite.visible = false
    is_invincible = true
    invincible_timer = invincible_time
    blink_timer = 0.0
    _set_flash_white(true)
    

func _set_flash_white(enabled: bool):
    if enabled == false:
        $AnimatedSprite2D/SilhouetteSprite.visible = true
        
    var mat = characterSprite.material
    if mat and mat is ShaderMaterial:
        mat.set_shader_parameter("flash_white", enabled)

func do_hit_stop(duration := 0.1):
    Engine.time_scale = 0.0

    var start = Time.get_ticks_msec()
    while Time.get_ticks_msec() - start < int(duration * 1000):
        await get_tree().process_frame  # yield one frame

    Engine.time_scale = 1.0

           
#func _on_jump_button_pressed():
    #print("JUmpp click btn")
    #if !is_jumping:
        #_start_jump()
#
#func _on_dash_button_pressed():
    #print("Dashhh click btn")
    #if !is_dashing and direction != Vector2.ZERO:
        #_start_dash()
