extends Node2D
class_name RandomPaletteGenerator

var divisor = 2
export (int, 0, 60) var max_offset = 20
export (int, 2, 8) var size = 2
export (float) var min_dif
onready var color_rect = ColorRect
var color_buffer
var color_s = 0
var color_h = 0

var swatch = []

export (bool) var generate_panels = false

var rng = RandomNumberGenerator.new()

func _ready():
	swatch = shuffle()

func shuffle():
	var colors = []
	var color_v
	rng.randomize()
	color_s = rng.randi_range(0, 100)
	color_h = rng.randi_range(0, 359)
	for x in range(size):
		color_v = rng.randi_range(50, 100)
		var chance = rng.randi_range(0, x)
		var color = Color(1, 1, 1)
		if x % divisor == 0:
			color_h = wrapf(color_h+180, 0, 360)
		color_v += rng.randi_range(-max_offset / 2, max_offset / 2)
		color_s += rng.randi_range(-max_offset / 2, max_offset / 2)
		color_h += rng.randi_range(-max_offset / 2, max_offset / 2)
		if chance == 3:
			var offset = 90 / rng.randi_range(1, 4)
			color_h = wrapf(color_h+offset, 0, 360)
		if colors.size() > divisor:
			if abs((colors[x-divisor].s *100)  - color_s) < min_dif:
				color_s += max_offset
			if abs((colors[x-divisor].v * 100) - color_v) < min_dif:
				color_v += max_offset
		color_h = (wrapf(color_h, 0, 360) / 360.0)
		color_s = (wrapf(color_s, 0, 100) / 100.0)
		color_v = (wrapf(color_v, 0, 100) / 100.0)
		color.s = color_s
		color.h = color_h
		color.v = color_v
		colors.append(color)
	
	if generate_panels:
		for _color in colors:
			var panel = color_rect.new()
			panel.color = _color
			panel.rect_min_size = Vector2(40, 40)
			$PaletteContainer.add_child(panel)
	
	return colors

func _on_Button_pressed():
	for c in $PaletteContainer.get_children():
		c.queue_free()
	swatch = shuffle()

func _on_Save_pressed():
	var swatch_save = ResourceLoader.load("res://Prototypes/ColorPickerPrototype/SwatchSaves.tres")
	swatch_save.saved_swatches.append(swatch)
	var _mes = ResourceSaver.save("res://Prototypes/ColorPickerPrototype/SwatchSaves.tres", swatch_save)
