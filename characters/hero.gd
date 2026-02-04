extends CharacterBody2D
class_name Hero

@onready var tree = $AnimationTree
@onready var sprite = $Body 
@onready var gun_sprite = $GunSprite

@export var speed := 100.0
@export var health := 100.0
@export var damage := 50.0


var dir := Vector2.ZERO
var time = 0.0
@export var bob_speed = 20.0   # How fast it bobs
@export var bob_height = 1.0  # How far it moves

func _ready():
	# This line activates the tree automatically when the game starts
	tree.active = true
	

func _physics_process(_delta):
	# 1. Get input and normalize it
	move()
	
	# 2. Apply movement
	velocity = dir * speed
	move_and_slide()
	
	# 3. Update animations
	update_animations()
	if dir != Vector2.ZERO:
		start_bobbing(_delta)
func move():
	# This one line replaces all the IF statements for move_right/left/up/down
	# It also handles normalization automatically
	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func update_animations():
	# We only update the blend position if the character is moving
	# This allows the character to stay facing the last direction when they stop
		
		
		# IMPORTANT: If your error "Vector2 and float" persists, 
		# check if your BlendSpace is 2D and matches this name:
		tree.set("parameters/BlendSpace2D/blend_position", dir)
		
			
		# Flip Sprite Logic
		# If moving left, flip the sprite. If moving right, unflip it.
		if dir.x < 0:
			sprite.flip_h = false
			gun_sprite.flip_h = true
		elif dir.x > 0:
			sprite.flip_h = true
			gun_sprite.flip_h = false
			
func start_bobbing(delta):
	time += delta
	# sin() creates a perfect smooth loop between -1 and 1
	# We multiply it by height to get the movement range
	$GunSprite.position.y = sin(time * bob_speed) * bob_height
