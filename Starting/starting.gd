extends Node2D

@export var start_platform_path: NodePath   # 指向 StartPlatform
@export var ui_root_path: NodePath          # 可选：标题/press start 的根节点

var started := false

func _ready() -> void:
	# 开场锁住玩家（通过 group 找）
	var p := get_tree().get_first_node_in_group("player")
	if p:
		p.can_control = false
		# 防止进入场景时带着速度
		p.velocity = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if started:
		return

	if event.is_action_pressed("jump") or event.is_action_pressed("ui_accept"):
		started = true
		start_game()

func start_game() -> void:
	# 1) 先解除玩家冻结（这样平台删掉立刻就会掉）
	var p := get_tree().get_first_node_in_group("player")
	if p:
		p.can_control = true
		# 可选：防止刚开始横向乱飘
		p.velocity.x = 0

	# 2) 再让平台消失
	var platform := get_node_or_null(start_platform_path)
	if platform:
		platform.queue_free()
		

	# 3) 可选：隐藏 UI
	var ui_root := get_node_or_null(ui_root_path)
	if ui_root:
		ui_root.visible = false
