extends CharacterBody2D

@export var speed: float = 600.0
@export var jump_velocity: float = -700.0
@export var can_control: bool = true  # false=开始界面不响应输入，true=正常游戏
@onready var anim: AnimatedSprite2D = $Cat
@onready var ColR: CollisionPolygon2D = $CollisionR
@onready var ColL: CollisionPolygon2D = $CollisionL

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func _physics_process(delta: float) -> void:
	# 1) 重力：永远都要算（平台消失才能掉下去）
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2) 输入：只有 can_control 才允许控制
	var dir := 0.0
	if can_control:
		dir = Input.get_axis("move_left", "move_right")
		velocity.x = dir * speed

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		
	else:
		velocity.x = 0.0

	# 3) 移动
	move_and_slide()

	# 4) 动画
	if not can_control:
		# 开始界面：固定 Idle/停住
		if anim.sprite_frames and anim.sprite_frames.has_animation("Idle"):
			anim.play("Idle")
		else:
			anim.stop()
		return

	# 正常游戏动画
	if dir != 0:
		anim.play("Move")
		if dir < 0:
			anim.flip_h = false
			anim.position.x = 0
			ColL.disabled = false
			ColR.disabled = true
			
			
		else:
			anim.flip_h = true
			anim.position.x = -73
			ColL.disabled = true
			ColR.disabled = false
			
			
	else:
		if anim.sprite_frames and anim.sprite_frames.has_animation("Idle"):
			anim.play("Idle")
		else:
			anim.stop()
