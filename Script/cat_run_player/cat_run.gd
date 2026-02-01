extends CharacterBody2D

@export var speed: float = 600.0
@export var jump_velocity: float = -700.0
@export var can_control: bool = true  # false=开始界面不响应输入，true=正常游戏
@onready var anim0: AnimatedSprite2D = $CatO
@onready var anim1: AnimatedSprite2D = $CatN
@onready var ColR: CollisionPolygon2D = $CollisionR
@onready var ColL: CollisionPolygon2D = $CollisionL
var dir:float = 0.0
var status:int = 0
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func turn(direction: int) -> void:
	if direction > 0:
		anim0.flip_h = true
		anim0.position.x = -73
		anim1.flip_h = true
		anim1.position.x = -73
		ColL.disabled = true
		ColR.disabled = false
	else:
		anim0.flip_h = false
		anim0.position.x = 0
		anim1.flip_h = false
		anim1.position.x = 0
		ColL.disabled = false
		ColR.disabled = true

func _ready() -> void:
	turn(1)
	
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta

	
	if can_control:
		dir = Input.get_axis("move_left", "move_right")
		velocity.x = dir * speed

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		if Input.is_action_just_pressed("Switch"):
			if status == 1:
				status = 0
			else:
				status +=1
		
	else:
		velocity.x = 0.0

	move_and_slide()

	if not can_control:
		
		if anim0.sprite_frames and anim0.sprite_frames.has_animation("Idle"):
			anim0.play("Idle")
		else:
			anim0.stop()
		return

	if status == 0:
		anim0.visible = true
		anim1.visible = false
		if dir != 0:
			anim0.play("MoveO")
			if dir < 0:
				turn(-1)
			else:
				turn(1)
		else:
			if anim0.sprite_frames and anim0.sprite_frames.has_animation("Idle"):
				anim0.play("Idle")
			else:
				anim0.stop()
	if status == 1:
		anim1.visible = true
		anim0.visible = false
		if dir != 0:
			anim1.play("MoveN")
			if dir < 0:
				turn(-1)
			else:
				turn(1)
		else:
			if anim1.sprite_frames and anim1.sprite_frames.has_animation("Idle"):
				anim1.play("Idle")
			else:
				anim1.stop()
