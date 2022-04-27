extends KinematicBody2D

var speed
var life_time

var penetration = 120
var damage_floating = 0.2
var damage = 100
export (PackedScene) var Smoke

func init(_speed, _life_time, _penetration, _damage, damage_floating):
	life_time = _life_time
	speed = _speed
	
func _ready():
	$LifeTimer.wait_time = life_time

func _physics_process(delta):
	move_and_collide(Vector2(speed, 0).rotated(rotation))

func explode():
	var smoke = Smoke.instance()
	smoke.transform = transform
	get_parent().add_child(smoke)
	queue_free()

func _on_LifeTimer_timeout():
	explode()

onready var ray_left = $RayCast2DLeft
onready var ray_right = $RayCast2DRight

func take_body_damage(body):
	if body.has_method("take_damage"):
		var global_point
		var normal
		ray_left.force_raycast_update()
		ray_right.force_raycast_update()
		if ray_left.is_colliding():
			global_point = ray_left.get_collision_point()
			normal = ray_left.get_collision_normal()
		elif ray_right.is_colliding():
			global_point = ray_right.get_collision_point()
			normal = ray_right.get_collision_normal()
		else:
			return
		var angle = Vector2(1, 0).rotated(global_rotation).angle_to(normal.rotated(PI))
		body.take_damage(global_point, abs(angle), penetration, damage, damage_floating)

func _on_HitBox_body_entered(body):
	if body != $".":
		take_body_damage(body)
		explode()
		
