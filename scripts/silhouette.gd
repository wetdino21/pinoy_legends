extends AnimatedSprite2D

@onready var _silhouette_sprite: AnimatedSprite2D = $SilhouetteSprite

func _ready() -> void:
    # Copy sprite frames and initial animation state
    _silhouette_sprite.sprite_frames = sprite_frames
    _silhouette_sprite.animation = animation
    _silhouette_sprite.frame = frame
    _silhouette_sprite.offset = offset
    _silhouette_sprite.flip_h = flip_h
    _silhouette_sprite.speed_scale = speed_scale

    frame_changed.connect(_on_frame_changed)
    animation_changed.connect(_on_animation_changed)

## Override play to sync both sprites
#func play(anim_name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false) -> void:
    #super.play(anim_name, custom_speed, from_end)
    #if _silhouette_sprite:
        #_silhouette_sprite.play(anim_name, custom_speed, from_end)

# Override frame changes
func _on_frame_changed():
    if _silhouette_sprite:
        _silhouette_sprite.frame = frame

# Override animation changes
func _on_animation_changed():
    if _silhouette_sprite:
        _silhouette_sprite.animation = animation
        _silhouette_sprite.frame = frame

func _set(property: StringName, value: Variant) -> bool:
    if is_instance_valid(_silhouette_sprite):
        match property:
            "sprite_frames":
                _silhouette_sprite.sprite_frames = value
            "animation":
                _silhouette_sprite.animation = value
            "frame":
                _silhouette_sprite.frame = value
            "offset":
                _silhouette_sprite.offset = value
            "flip_h":
                _silhouette_sprite.flip_h = value
            "speed_scale":
                _silhouette_sprite.speed_scale = value
    return false




# # Set the initial values of the rilevant
# func _ready() -> void:
#     #_silhouette_sprite.texture = texture
#     _silhouette_sprite.offset = offset
#     _silhouette_sprite.flip_h = flip_h
#     #_silhouette_sprite.hframes = hframes
#     #_silhouette_sprite.vframes = vframes
#     _silhouette_sprite.frame = frame

# # Set the silhouette sprite's properties when they are changed
# func _set(property: StringName, value: Variant) -> bool:
#     if is_instance_valid(_silhouette_sprite):
#         match property:
#             #"texture":
#                 #_silhouette_sprite.texture = value
#             "offset":
#                 _silhouette_sprite.offset = value
#             "flip_h":
#                 _silhouette_sprite.flip_h = value
#             #"hframes":
#                 #_silhouette_sprite.hframes = value
#             #"vframes":
#                 #_silhouette_sprite.vframes = value
#             "frame":
#                 _silhouette_sprite.frame = value
#     return false
