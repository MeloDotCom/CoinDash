extends Area2D

signal pickup(type: String)
signal hurt

@export var speed: float = 350.0
var velocity: Vector2 = Vector2.ZERO
var joystick_velocity: Vector2 = Vector2.ZERO
var screensize: Vector2 = Vector2(480, 720)
var is_dead: bool = false
		
func _process(delta: float) -> void:
	if is_dead:
		return

	var input_velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Usa a entrada do joystick se houver movimento, caso contrário, usa as setas
	if joystick_velocity.length() > 0:
		velocity = joystick_velocity
	else:
		velocity = input_velocity

	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	update_animation()
	
func update_animation() -> void:
	if is_dead:
		$AnimatedSprite2D.animation = "hurt"
		return

	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func start() -> void:
	set_process(true)
	position = screensize / 2
	is_dead = false
	velocity = Vector2.ZERO
	joystick_velocity = Vector2.ZERO  # Zera o movimento do joystick
	update_animation()

func die() -> void:
	is_dead = true
	update_animation()
	set_process(false)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.queue_free()
		pickup.emit("coin")
	elif area.is_in_group("powerups"):
		area.queue_free()
		pickup.emit("powerup")
	elif area.is_in_group("obstacles"):
		hurt.emit()
		die()

func _on_virtual_joystick_analogic_change(move: Vector2) -> void:
	if is_dead:
		return

	joystick_velocity = move

func _on_spin_box_value_changed(value: float) -> void:
	speed = value
