extends RayCast2D

onready var vision = $Line2D
var penetration

func move(mouse_position, max_distance, delta):
	var mounse_distance = mouse_position.distance_to(global_position)
	var clamp_distance = clamp(mounse_distance, 0, max_distance)
	cast_to.x = clamp_distance	
	force_raycast_update()
	var nearest_body_distance = clamp_distance
	vision.default_color = Color.green
	if is_colliding():
		nearest_body_distance = get_collision_point().distance_to(global_position)
		var target = get_collider()
		if target.has_method("can_break_armo"):
			var angle = Vector2(1, 0).rotated(global_rotation).angle_to(get_collision_normal().rotated(PI))
			if !target.can_break_armo(get_collision_point(), angle, penetration):
				vision.default_color = Color.red
	vision.points[1].x = nearest_body_distance
	look_at(mouse_position)
