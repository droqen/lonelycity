extends Node2D

@export var player : Node2D

const C_CLOUD = Color(.6,.6,.8,.1)
const C_RED = Color(.7,.4,.4,.8)
const C_ORIGINAL_COIN = Color(.9,.9,.0,.8)
const C_WORN_COIN = Color(.85,.7,.3,.7)

class Circle:
	var blossom : float = 0.0
	var blossomrate : float = 0.01
	var x : float
	var y : float
	var vx : float
	var vy : float
	var dir : float
	var rad : float
	var hitrad : float
	var col : Color
	var kill : int = 0
	var ring : float = -1
	var boundary : int = 500
	func _init():
		rerand()
		rad = randf_range(20,40)
		col = C_RED
		blossomrate = randf_range(0.04,0.06)
	func rerand():
		x = randf_range(-boundary,boundary)
		y = randf_range(-boundary,boundary)
		vx = randf_range(-1,1)
		vy = randf_range(-1,1)
	func step():
		if blossom < 1.0:
			x += vx * blossom
			y += vy * blossom
			blossom += blossomrate * (0.02+0.98*blossom)
			if blossom > 1.0: blossom = 1.0
		elif kill > 0:
			kill -= 1
		else:
			x += vx
			y += vy
			if x < -boundary and vx < 0: vx *= -1
			if y < -boundary and vy < 0: vy *= -1
			if x > boundary and vx > 0: vx *= -1
			if y > boundary and vy > 0: vy *= -1
	func draw(c:CanvasItem):
		if blossom < 1.0:
			if ring > 0:
				var cola = col
				cola.a = blossom
				c.draw_circle(Vector2(x,y),ring,cola,false,-1,true)
			else:
				c.draw_circle(Vector2(x,y),rad*lerp(1.0,0.5,blossom),col,false,rad*lerp(0.01,1.0,blossom),true)
		elif kill < 0:
			pass
		elif kill > 0:
			c.draw_circle(Vector2(x,y),rad+randf_range(0.09,0.10)*kill,Color(1,1,1,col.a),true,-1,true)
		else:
			if ring > 0:
				c.draw_circle(Vector2(x,y),ring,col,false,-1,true)
				if ring < rad + 50:
					var cola = col
					cola.a = remap(ring, rad, rad+50, 1.0, 0.0)
					c.draw_circle(Vector2(x,y),rad,cola,true,-1,true)
			else:
				c.draw_circle(Vector2(x,y),rad,col,true,-1,true)
	func hits(pos:Vector2) -> bool:
		var r : float = rad + hitrad
		if ring > 0:
			ring = minf(ring, pos.distance_to(Vector2(x,y)))
			if ring < r:
				return true
			else:
				return false
		if blossom < 1.0: return false
		return (
			pos.x > x-r and pos.x < x+r and pos.y > y-r and pos.y < y+r
			and pos.distance_to(Vector2(x,y))<r
		)

var killcircles : Array[Circle]
var oxygencircles : Array[Circle]
var coincircles : Array[Circle]

func _ready() -> void:
	for i in range(100):
		killcircles.append(Circle.new())
		if i < 10: coincircles.append(Circle.new())
		oxygencircles.append(Circle.new())
	for oc in oxygencircles:
		oc.boundary = 1000; oc.x *= 2; oc.y *= 2;
		oc.vx *= 0.5
		oc.vy *= 0.5
		oc.rad *= 2.5
		oc.col = C_CLOUD
	for cc in coincircles:
		cc.boundary = 400; cc.x *= 0.8; cc.y *= 0.8;
		cc.rad = randf_range(6,9)
		cc.hitrad = 3
		cc.col = C_ORIGINAL_COIN
		cc.ring = 999
 
func _physics_process(_delta: float) -> void:
	for c in killcircles:
		c.step()
		if c.hits(player.position):
			c.kill = 100
	for c in oxygencircles:
		c.step()
		if c.hits(player.position):
			c.kill = 1
	for c in coincircles:
		c.step()
		if c.kill == 0 and c.hits(player.position):
			#c.col = C_WORN_COIN
			c.kill = 12
		if c.kill == 3:
			c.rerand()
			c.rad = randf_range(6,9)
			c.ring = 999
			c.kill = 0
			c.blossom = 0.0
	queue_redraw()

func _draw() -> void:
	for c in oxygencircles+killcircles+coincircles:
		c.draw(self)
