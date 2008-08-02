#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"
require "ftgl"

include Gl
include Glu

require "../../lib/trogl.rb" 

class FontTester

	def initialize(font_file="BADACID.TTF")
		font_size = 30
		@font = FTGL::PolygonFont.new(font_file)
		#font = FTGL::TextureFont.new(font_file)
		@font.SetFaceSize(font_size)

		@alpha = 0
	end
	
	def draw
		glMatrixMode(GL_MODELVIEW)
		text = "This is a big TEXT, right ?"
		glPushMatrix
		res = glGetFloatv(GL_MODELVIEW_MATRIX)
		p res.inspect
		#glLoadIdentity
		#glEnable(GL_TEXTURE_2D)
		#glDisable(GL_TEXTURE_2D)
		glTranslate(0,5,0)
		glScale(0.2,0.2,0.2)
		#glRotate(@alpha,1,0,0)
		@alpha+=1
		@font.Render(text)
		glFinish
		glPopMatrix
	end
end

#===========================================
# main
#===========================================

#MODE = :small 
#MODE = :wide
#MODE = :flat
#MODE = :narrow
#MODE = :square
MODE = :square
case MODE
	when :square
		$w=$h=600
	when :wide
		$w = 1280
		$h = 700
	when :flat
		$w = 1200
		$h = 500
	when :narrow
		$w= 400
		$h= 800
	when :small
		$w = 300
		$h = 200
end

gl_scene = Trogl::Scene.new({:width => $w, :height => $h, :fov => 70, :caption => ".oO[ trogl/ruby testing fonts/ftgl ]Oo."})
gl_scene.light.on=true
gl_scene.target_fps=30

font_file = "256BYTES.TTF"
f = FontTester.new(font_file)
gl_scene.entities.push(f)

# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )

gl_scene.bind_key(SDL::Key::A		, Proc.new {gl_scene.cam.straff(-0.2)} )
gl_scene.bind_key(SDL::Key::D		, Proc.new {gl_scene.cam.straff(0.2)} )
gl_scene.bind_key(SDL::Key::W		, Proc.new {gl_scene.cam.move_fw(0.2)} )
gl_scene.bind_key(SDL::Key::S		, Proc.new {gl_scene.cam.move_fw(-0.2)} )
gl_scene.bind_key(SDL::Key::SPACE	,Proc.new {gl_scene.cam.move_up(0.2)} )

mouse_callback = Proc.new do |event|
	if ( (event.x==50) && (event.y==50) )
	else
		gl_scene.cam.rot_x(event.yrel/200.0)
		gl_scene.cam.rot_vert(-event.xrel/200.0)
		
		SDL::Mouse.warp(50,50) if ( gl_scene.mouse_grab ) # that stupid mouse warp generates ans SDL::Event2::MouseMotion .... have to ignore it somehow ...
	end
end

gl_scene.bind_mouse(mouse_callback)

gl_scene.cam.front=Vec.new([0,0,-1])
gl_scene.cam.up=Vec.new([0,1,0])
gl_scene.cam.pos=[30,5,50]

gl_scene.start {}

