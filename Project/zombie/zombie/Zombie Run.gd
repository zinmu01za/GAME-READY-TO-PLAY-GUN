extends KinematicBody


var wait_time = 0.0
var end_time = 0.1
var hp = 3.0 
var destroy_time = 0.2

const ACCEL = 5.0
const DEACCEL = 20.0
const MAX_SPEED = 2.0
const ROT_SPEED = 1.0

var prev_advance = false
var dying = false
var rot_dir = 4

onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * ProjectSettings.get_setting("physics/3d/default_gravity_vector")


var status=0
var live=0

var speed=0
var to

var movement = Vector2(2,-1)

var dead = false

var tween

export var durability : int = 100;
var remove_decal : bool = false;

	
func _ready1():
	$timer.connect("timeout", self, "queue_free");
	$explosion/timer.connect("timeout", self, "_explode_others");
	

	
	set_process_input(true)	
	
	tween=Tween.new()
	add_child(tween)
	tween.start()


func _process(_delta) -> void:
	_remove_decal();

func _explosion() -> void:
	$collision.disabled = true;
	
	var main = get_tree().get_root().get_child(0);
	
	var burnt_ground = preload("res://data/scenes/burnt_ground.tscn").instance();
	main.add_child(burnt_ground);
	burnt_ground.translation = global_transform.origin;
	
	
	$RootNode.visible = false;
	$effects/ex.emitting = true;
	$effects/plo.emitting = true;
	$effects/sion.emitting = true;
	$audios/explosion.pitch_scale = rand_range(0.9, 1.1);
	$audios/explosion.play();
	
	remove_decal = true;

func _remove_decal():
	if remove_decal:
		for child in get_child_count():
			if get_child(child).is_in_group("decal"):
				get_child(child).queue_free();

func _explode_others():
	for bodie in $explosion.get_overlapping_bodies():
		if bodie.has_method("_damage") and bodie != self:
			if "durability" in bodie:
				if bodie.durability > 0:
					var explosion_distance = (5 * bodie.global_transform.origin.distance_to(global_transform.origin));
					bodie._damage(300 - explosion_distance);

func _integrate_forces(state):
	var delta = state.get_step()
	var lv = state.get_linear_velocity()
	var g = state.get_total_gravity()
	# get_total_gravity returns zero for the first few frames, leading to errors.
	if g == Vector3.ZERO:
		g = gravity

	lv += g * delta # Apply gravity.
	var up = -g.normalized()

	if dying:
		state.set_linear_velocity(lv)
		return

	for i in range(state.get_contact_count()):
		var cc = state.get_contact_collider_object(i)
		var dp = state.get_contact_local_normal(i)


	var col_floor = get_node("mesh/RayFloor").is_colliding()
	var col_wall = get_node("mesh/RayWall").is_colliding()

	var advance = col_floor and not col_wall

	var dir = get_node("mesh").get_transform().basis[2].normalized()
	var deaccel_dir = dir

	if advance:
		if dir.dot(lv) < MAX_SPEED:
			lv += dir * ACCEL * delta
		deaccel_dir = dir.cross(g).normalized()
	else:
		if prev_advance:
			rot_dir = 1

		dir = Basis(up, rot_dir * ROT_SPEED * delta).xform(dir)
		get_node("mesh").set_transform(Transform().looking_at(-dir, up))

	var dspeed = deaccel_dir.dot(lv)
	dspeed -= DEACCEL * delta
	if dspeed < 0:
		dspeed = 0

	lv = lv - deaccel_dir * deaccel_dir.dot(lv) + deaccel_dir * dspeed

	state.set_linear_velocity(lv)
	prev_advance = advance


func _die():
	queue_free()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_hurbox_area_entered(area):
	if area.is_in_group("shoot"):
		dead = true
		$AnimationPlayer.play("dead")
