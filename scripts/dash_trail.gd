extends CPUParticles2D

@export var textures: Array[Texture2D] # List of textures for random selection
@export var texture_switch_interval: float = 0.03 # Time between texture changes
var texture_timer: float = 0.0
var is_emitting: bool = false

func _ready() -> void:
    # Ensure textures are loaded
    if textures.is_empty():
        textures = [
            load("res://assets/texture/lightning.png"),
            load("res://assets/texture/lightning2.png"),
            load("res://assets/texture/lightning3.png")
        ]
    # Set initial texture
    texture = textures[randi() % textures.size()]
    emitting = false # Start off, controlled by player

func _process(delta: float) -> void:
    if is_emitting:
        texture_timer += delta
        if texture_timer >= texture_switch_interval:
            # Randomly select a new texture
            texture = textures[randi() % textures.size()]
            texture_timer = 0.0

#func start_emitting() -> void:
    #is_emitting = true
    #emitting = true
    #texture_timer = 0.0
    #texture = textures[randi() % textures.size()] # Set initial texture on start
#
#func stop_emitting() -> void:
    #is_emitting = false
    #emitting = false
