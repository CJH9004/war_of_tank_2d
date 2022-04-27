extends KinematicBody2D

# 属性
export (int) var max_forward_speed = 100
export (int) var max_rotation_speed = 1
export (int) var max_turret_rotation_speed = 1
export (int) var max_telescope_distance = 400
export (float) var gun_cool_down = 0.3
export (int) var bullet_speed = 100
export (float) var bullet_life_time = 1
export (float) var bullet_penetration = 120
export (float) var bullet_damage_floating = 0.2
export (float) var bullet_damage = 100
export (float) var armo_front = 100
export (float) var armo_back = 30
export (float) var armo_side = 50
export (int) var health = 1000
export (PackedScene) var Bullet

# 必须具有的附件
onready var telescope = $Telescope
onready var turret = $Turret
onready var muzzle = $Turret/Muzzle

func _ready():
	turret.gun_cool_down_timer.wait_time = gun_cool_down
	telescope.penetration = bullet_penetration

# 根据输入来移动坦克
func move_and_slide_body(input, delta):
	rotation += input.x * max_rotation_speed * delta
	move_and_slide(Vector2(input.y * max_forward_speed, 0).rotated(rotation))
	
# 根据输入来移动望远镜
func move_telescope(mouse_position, delta):
	telescope.move(mouse_position, max_telescope_distance, delta)
	turret.move(telescope.rotation, delta)

func shoot():
	return turret.shoot(
		Bullet, 
		bullet_speed, 
		bullet_life_time, 
		bullet_penetration, 
		bullet_damage, 
		bullet_damage_floating)

onready var front_left_angle = $FrontLeft.position.angle()
onready var front_right_angle = $FrontRight.position.angle()
onready var back_left_angle = $BackLeft.position.angle()
onready var back_right_angle = $BackRight.position.angle()

enum ARMO_DIRECTION {FRONT, BACK, RIGHT, LEFT}

func get_armo_direction(global_point):
	var point = to_local(global_point)
	var point_angle = point.angle()
	if point_angle < front_right_angle && point_angle > front_left_angle:
		# attack from front
		return ARMO_DIRECTION.FRONT
	elif point_angle < back_left_angle || point_angle > back_right_angle:
		return ARMO_DIRECTION.BACK
	elif point.y > 0:
		return ARMO_DIRECTION.LEFT
	return ARMO_DIRECTION.RIGHT

func get_armo(global_point):
	var armo_direction = get_armo_direction(global_point)
	if  armo_direction == ARMO_DIRECTION.FRONT:
		return armo_front
	if  armo_direction == ARMO_DIRECTION.BACK:
		return armo_back
	return armo_side

func get_valid_penetration(angle, penetration):
	return penetration*cos(angle)

signal hit
signal destoried

func explode():
	pass

func take_damage(global_point, angle, penetration, damage, damage_floating):
	var damage_value = 0
	var armo = get_armo(global_point)
	var valid_penetration = get_valid_penetration(angle, penetration)
	if armo < valid_penetration:
		damage_value = damage + rand_range(-damage_floating, damage_floating) * damage
		health -= int(damage_value)
		health = clamp(health, 0, INF)
		emit_signal("hit")
		if health <= 0:
			emit_signal("destoried")
			explode()
	return damage_value

func can_break_armo(global_point, angle, penetration):
	var armo = get_armo(global_point)
	var valid_penetration = get_valid_penetration(angle, penetration)
	return armo < valid_penetration
	
