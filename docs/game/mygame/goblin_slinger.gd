extends CharacterBody2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
var speed = 50
var last_direction = Vector2.ZERO
var animated_sprite
var direction_change_timer = 0
var direction_change_interval = 5
var run_speed = 75
var run = false
var player = null
var player_in_range = false


func _ready():
	animated_sprite = $AnimatedSprite2D
	# Picks a random direction for the sprite to start in
	pick_random_direction()
	
func _physics_process(delta):
	
	# counting the time since start
	direction_change_timer += delta
	if direction_change_timer >= direction_change_interval:
		pick_random_direction() # Changes direction after timer reaches 5 seconds
		direction_change_timer = 0 # Resets timer
	
	velocity = last_direction * speed
	
		
	if last_direction.x < 0:
		animated_sprite.play("walk_left")
	elif last_direction.x > 0:
		animated_sprite.play("walk_right")
	elif last_direction.y < 0:
		animated_sprite.play("walk_up")
	elif last_direction.y > 0:
		animated_sprite.play("walk_down")
	else:
		animated_sprite.play("idle_down")
		
	if run:
		var direction_to_player = (player.position - position).normalized
		navigation_agent.target_position = target_to_chase.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * run_speed
		
	move_and_slide()

# Picks a random direction for enemy
func pick_random_direction():
	var new_direction = Vector2.ZERO
	#Ensure that the direction is never a zero vector
	while new_direction == Vector2.ZERO:
		new_direction = Vector2(randi() % 3 - 1, randi() % 3 - 1)
	new_direction = new_direction.normalized()
	last_direction = new_direction # Update last direction variable


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_territory_body_entered(body: Node2D) -> void:
	player = body
	run = true


func _on_territory_body_exited(body: Node2D) -> void:
	player = null
	run = false