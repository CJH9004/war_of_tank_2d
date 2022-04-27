extends Node2D

var can_shoot = false

onready var gun_cool_down_timer = $GunCoolDownTimer
onready var muzzle = $Muzzle

# 移动炮塔到望目标方向
func move(target_rotation, delta):
	var need_rotation = target_rotation - rotation
	need_rotation -= int(need_rotation/(PI*2))*PI*2
	if need_rotation > PI:
		need_rotation = need_rotation-PI
	if need_rotation < -PI:
		need_rotation = -need_rotation-PI
	rotation = move_toward(rotation, rotation+need_rotation, delta)

func shoot(Bullet, speed, life_time, penetration, damage, damage_floating):
	if can_shoot:
		var bullet = Bullet.instance()
		bullet.set_global_transform(muzzle.global_transform)
		bullet.init(speed, life_time, penetration, damage, damage_floating)
		can_shoot = false
		gun_cool_down_timer.start()
		return bullet
	return null

func _on_GunCoolDownTimer_timeout():
	gun_cool_down_timer.stop()
	can_shoot = true
