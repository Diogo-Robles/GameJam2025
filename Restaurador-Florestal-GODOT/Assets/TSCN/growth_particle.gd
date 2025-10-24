extends AnimatedSprite3D
@onready var Timing : Timer = $Timer
var is_playing = false

func start_effect():	
	if is_playing:
		return
	is_playing = true
	
	while is_playing:

		self.visible = true
		play("1")
		await animation_finished
		self.visible = false
		Timing.wait_time = 5.0
		Timing.one_shot = true
		Timing.start()
		await Timing.timeout
	
func stop_effect():
	is_playing = false
	stop()
	self.visible = false

	queue_free()
