#extends Node2D
#
##@onready var Joystick = $Joystick  # Adjust to match your node path
#
#func _ready():
    #$CanvasModulate.visible = true
    #
    


#fireflies NODE2D

extends Node2D

@export var firefly_scene := preload("res://scenes/fire_fly.tscn")
@export var tilemap_node_path := NodePath("TileMap/ground")
@export var spawn_rate := 0.1
@export var spawn_radius := 1000.0

var tile_positions: Array[Vector2i] = []
var tilemap_layer: TileMapLayer
var player: Node2D

func _ready():
    $CanvasModulate.visible = true
    tilemap_layer = get_node(tilemap_node_path)
    tile_positions = tilemap_layer.get_used_cells()

    # Get player from "Player" group
    var players = get_tree().get_nodes_in_group("player")
    if players.size() > 0:
        player = players[0]
    else:
        push_warning("No node in 'Player' group found!")

func _process(delta):
    if player == null:
        return

    if randf() < spawn_rate and tile_positions.size() > 0:
        var cell = tile_positions[randi() % tile_positions.size()]
        var world_pos = tilemap_layer.to_global(tilemap_layer.map_to_local(cell)) + Vector2(16, 16)

        if player.global_position.distance_to(world_pos) <= spawn_radius:
            var firefly = firefly_scene.instantiate()
            firefly.position = world_pos
            add_child(firefly)
            #print("firelyy")

    
