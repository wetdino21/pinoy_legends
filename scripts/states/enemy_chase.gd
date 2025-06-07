extends State
class_name enemy_chase

@export var enemy: CharacterBody2D
@export var move_speed := 80.0
var player: CharacterBody2D

func enter():
    player = get_tree().get_first_node_in_group("player")

func update(delta: float):
    pass
    
func physics_update(delta: float):
    #print("player:", player.global_position)
    #print("player:", enemy.global_position)
     
    var direction1 = player.global_position
    var direction2 = enemy.global_position
    
    var direction = direction1 - direction2
    
    if direction.length() < 100:
        enemy.velocity = direction.normalized() * move_speed
    else:
        Transitioned.emit(self, "idle")
