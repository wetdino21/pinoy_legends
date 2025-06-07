extends State
class_name enemy_idle

@export var enemy: CharacterBody2D
@export var enemycollision: CollisionShape2D
@export var move_speed := 50.0
var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float

func wander_randomize():
    move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
    wander_time = randf_range(1,3)
    
func enter():
    enemycollision.disabled = false
    player = get_tree().get_first_node_in_group("player")
    wander_randomize()
    
    
func update(delta: float):
    if wander_time > 0:
        wander_time -= delta
    else:
        wander_randomize()
        
func physics_update(delta: float):
    if enemy:
        enemy.velocity = move_direction * move_speed
    
    var direction = player.global_position - enemy.global_position
    if direction.length() < 100:
        enemy.velocity = Vector2.ZERO
        enemycollision.disabled = true
        Transitioned.emit(self, "head_chase")
        
