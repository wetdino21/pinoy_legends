extends SubViewport

@onready var camera = $Camera2D
var player

func _ready():
    world_2d = get_tree().root.world_2d
    player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
    if player:
        camera.position = player.position
