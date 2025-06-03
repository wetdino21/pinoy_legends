extends Node2D

@export var lifetime: float = 10.0
@export var fade_start: float = 8.0  # When to start fading

@onready var sprite = $Sprite2D

func _ready():
    # Start fading after fade_start seconds
    var tween = create_tween()
    tween.tween_property(sprite, "modulate:a", 0.0, lifetime - fade_start)
    tween.tween_callback(queue_free)
    
    # Add initial random squish to make drops look more natural
    var squish = randf_range(0.8, 1.2)
    sprite.scale = Vector2(squish, 1.0/squish)  # Maintain area while squishing
