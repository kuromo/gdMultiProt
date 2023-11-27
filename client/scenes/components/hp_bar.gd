extends TextureProgressBar

class_name HPBar


@export var underTint = "0e0e0ebc"
@export var overTint = "c3aa00eb"
#diffrent progres tints depending on health. handledn in update()
@export var fullTint = "29ad00c7"
@export var halfTint = "c66300c7"
@export var lowTint = "910000c7"

# couldnt set textures in code so need to add them manually
# and need to enable "Nine Patch Strecht" to downscale

func _ready():
	self.set_tint_progress(fullTint)
	self.set_tint_under(underTint)
	self.set_tint_over(overTint)
	self.value = 100

func _process(delta):
	pass

func update():
	self.value = int((float(owner.currentHealth) / owner.maxHealth) * 100)
	
	if(self.value >= 60):
		self.set_tint_progress(fullTint)
	elif(self.value < 50 && self.value >= 25):
		self.set_tint_progress(halfTint)
	elif(self.value < 25):
		self.set_tint_progress(lowTint)
