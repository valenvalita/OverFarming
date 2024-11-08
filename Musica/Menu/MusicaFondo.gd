extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func musica_fondo(musica):
	self.stream = musica
	self.play()
func parar_musica():
	self.stop()
