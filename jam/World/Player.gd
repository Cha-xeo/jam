extends KinematicBody2D

var velocity = Vector2()
export var WALK_FORCE = 600
export var WALK_MAX_SPEED = 200
export var STOP_FORCE = 1300
export var JUMP_SPEED = 200

onready var animationPlayer = $AnimationPlayer
onready var animationSkull = $AnimatedSkullSprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var shape = $Shape

enum {
	JUMPING,
	IDLING,
	RUNNING
}

var state = IDLING

func _ready():
	animationTree.active = true

func move(delta, walk):
	if abs(walk) < WALK_FORCE * 0.2:
		state = IDLING
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		state = RUNNING
		velocity.x += walk * delta
	if Input.is_action_pressed("ui_up") && is_on_floor():
		state = JUMPING
		velocity.y = -JUMP_SPEED
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func animation():
	if is_on_floor():
		if state == RUNNING:
			animationState.travel("Run")
		else:
			animationState.travel("Idle")
	else:
		animationState.travel("jump")

func _physics_process(delta):
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	var walk = WALK_FORCE * (right - left)
	if right < left:
		animationSkull.flip_h = false
	else:
		animationSkull.flip_h = true
	if walk != 0:
		animationTree.set("parameters/Idle/blend_position", walk)
		animationTree.set("parameters/Run/blend_position", walk)
		animationTree.set("parameters/jump/blend_position", walk)
	move(delta, walk)
	animation()

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	queue_free()
