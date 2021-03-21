extends KinematicBody2D
var speedfactor = 50
var motion = Vector2()
var Enemybullet = preload("res://game/EnemyBullet.tscn")
var bulletspeed = 2000
var alive = true
	
var fire_rate : float = 1 #Fire rate 10 bullets per second
onready var update_delta : float = 1 / fire_rate
var current_time : float = 0


func _ready():
	pass
	
func _physics_process(delta):
	if alive:
		var Player = get_parent().get_node("Player")
		position += (Player.position - position) / speedfactor
	
		look_at(Player.position)
		move_and_collide(motion)
	
func _process(delta):	
	current_time += delta
	if (current_time < update_delta):
		return
	current_time = 0
	if alive:
		fire()

func death():	
	alive = false
	if !$enemyDeath.playing:
		$enemyDeath.play()
	$Sprite.hide()
	$Particles2D.hide()
	$deathParticles.emitting = true
	yield(get_tree().create_timer(1.0), "timeout")
	$deathParticles.emitting = false		
	queue_free()

func _on_Area2D_body_entered(body):
	if "Playerbullet" in body.name:
		death()
	if "Player" in body.name:
		death()

func fire():
	var Enemybullet_instance = Enemybullet.instance()
	Enemybullet_instance.position = get_global_position() 
	Enemybullet_instance.rotation_degrees = rotation_degrees
	Enemybullet_instance.apply_impulse(Vector2(), Vector2(bulletspeed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", Enemybullet_instance)
	if !$enemyShoot.playing:
		$enemyShoot.play()