extends State
class_name enemy_head_chase

@export var enemy_body: CharacterBody2D
@export var enemy_head: CharacterBody2D
#@export var collision: CollisionShape2D
@export var move_speed := 80.0
@export var chase_duration: float = 10.0
@export var roam_duration: float = 5.0
var player: CharacterBody2D
var chase_timer: float = 0.0
var roam_timer: float = 0.0
var attached: bool = false
var is_roaming: bool = false

func roam_randomize():
    enemy_head.velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * move_speed

func enter():
    player = get_tree().get_first_node_in_group("player")
    #collision.disabled = false
    attached = false
    chase_timer = chase_duration
    roam_timer = 0.0
    is_roaming = false
    print("chase enter")

func update(delta: float):
    chase_timer -= delta
    if is_roaming:
        roam_timer -= delta
        if roam_timer <= 0:
            roam_randomize() # Refresh roaming direction
            roam_timer = roam_duration

func physics_update(delta: float):
    var direction_to_player = player.global_position - enemy_head.global_position
    var direction_to_body = enemy_body.global_position - enemy_head.global_position

    if attached:
        enemy_head.velocity = Vector2.ZERO
        #collision.disabled = true
        Transitioned.emit(self, "idle")
        return

    if chase_timer <= 0:
        # Return to body
        enemy_head.velocity = direction_to_body.normalized() * move_speed
        is_roaming = false
        if direction_to_body.length() <= 5:
            enemy_head.global_position = enemy_body.global_position
            attached = true
    elif direction_to_player.length() > 200:
        # Roam randomly
        if not is_roaming:
            roam_randomize()
            roam_timer = roam_duration
            is_roaming = true
        # Keep existing velocity from roam_randomize()
    else:
        # Chase player
        enemy_head.velocity = direction_to_player.normalized() * move_speed
        is_roaming = false
