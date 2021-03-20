extends Node2D

export (int, 0, 60) var max_offset = 20
export (int, 2, 8) var no_of_colors = 2
onready var color_rect = ColorRect
var color_buffer
var color_s = 0
var color_h = 0
var rng = RandomNumberGenerator.new()

func _ready():
	shuffle()

func shuffle():
	var color_v
	rng.randomize()
	color_s = rng.randi_range(0, 100)
	color_h = rng.randi_range(0, 359)
	if no_of_colors >= 1:
		for x in range(no_of_colors):
			color_v = rng.randi_range(50, 100)
			var chance = rng.randi_range(0, x)
			var color = Color(1, 1, 1)
			if x % 2 == 0:
				color_h = wrapf(color_h+180, 0, 360)
			color_v += rng.randi_range(-max_offset / 4, max_offset / 2)
			color_s += rng.randi_range(-max_offset / 2, max_offset / 2)
			color_h += rng.randi_range(-max_offset / 2, max_offset / 2)
			if chance == 3:
				var offset = 90 / rng.randi_range(1, 4)
				color_h = wrapf(color_h+offset, 0, 360)
			color_h = clamp(color_h, 0, 360)
			color_s = clamp(color_s, 0, 100)
			color.v = range_lerp(color_v, 0, 100, 0, 1)
			color.s = range_lerp(color_s, 0 ,100, 0, 1)
			color.h = range_lerp(color_h, 0 ,360, 0, 1)
			var blot = color_rect.new()
			blot.color = color
			color_buffer = color
			print(color.to_html(false))
			blot.rect_min_size = Vector2(40, 40)
			$PaletteContainer.add_child(blot)
		
#		$Sprite.material.set("shader_param/color2", $PaletteContainer.get_child(1).color)
#		$Sprite.material.set("shader_param/color4", $PaletteContainer.get_child(0).color)

func _on_Button_pressed():
	for c in $PaletteContainer.get_children():
		c.queue_free()
	shuffle()
