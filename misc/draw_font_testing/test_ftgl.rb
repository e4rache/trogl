#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"
require "ftgl"

include Gl
include Glu

require "../../lib/trogl.rb" 

class Font

	def initialize(font_file="BADACID.TTF")
		font_size = 30
		@font = FTGL::PolygonFont.new(font_file)
		#font = FTGL::TextureFont.new(font_file)
		@font.SetFaceSize(font_size)

		@alpha = 0
	end
	
	def hud_draw
		glMatrixMode(GL_PROJECTION)
		glPushMatrix()	
		glLoadIdentity()
		glOrtho(0,1000,1000,0,-1.0,1.0)
		glMatrixMode(GL_MODELVIEW)
		glPushMatrix
		glLoadIdentity
		yield
		glPopMatrix
		glMatrixMode(GL_PROJECTION)
		glPopMatrix()
	end
	
	def draw
		hud_draw do
			glColor(0.0,0.0,0.0)
			glBegin(GL_QUADS)
				glVertex(0,0)
				glVertex(1000,0)
				glVertex(1000,50)
				glVertex(0,50)
			glEnd
			glColor(1,1,1)
			glBegin(GL_LINES)
				glVertex(1,1)
				glVertex(1000,1)

				glVertex(1,51)
				glVertex(1000,51)
			glEnd
			glTranslate(30,40,0)
			ftgl_test "Here Comes The Title 1234"
			glFinish
		end
		glMatrixMode(GL_MODELVIEW)
	#	glLoadIdentity
		ftgl_test2 "This is a big TEXT, right ?"

	end

	def ftgl_test(text="Cordyceps Fungus The mind-control Killer Fungi")
		glPushMatrix
		glScale(2,-2,1)
		glDisable(GL_TEXTURE_2D)
		@font.Render(text)
		glFinish
		glPopMatrix
	end

	def ftgl_test2(text="Cordyceps Fungus The mind-control Killer Fungi")
		glPushMatrix
		#glEnable(GL_TEXTURE_2D)
		#glDisable(GL_TEXTURE_2D)
		glTranslate(0,5,0)
		glScale(0.2,0.2,0.2)
		#glRotate(@alpha,1,0,0)
		@alpha+=1
		p @alpha
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
MODE = :square
MODE = :wide
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

gl_scene = Trogl::Scene.new({:width => $w, :height => $h, :fov => 70, :caption => ".oO[ trogl/ruby Nehe Lesson 24 - e4rache ]Oo."})
gl_scene.light.on=true
gl_scene.target_fps=30

#font_file = "verdana.ttf"
#font_file = "Forgotty.ttf"
#font_file = "Acidic.ttf"
font_file = "Another_.ttf"
#font_file = "actionj.ttf"
#font_file = "BADACID.TTF"
#font_file = "TRIBTWO_.ttf"
#font_file = "AGENO___.TTF"
#font_file = "Albert.ttf"
#font_file = "BASIF___.TTF"
#font_file = "ALBA____.TTF"
font_file = "Bac_____.TTF"
font_file = "256BYTES.TTF"
f = Font.new(font_file)
gl_scene.entities.push(f)

cube_tex = Trogl::Object3d::CubeTex.new("../../data/pic/Tecplate.jpg")
cube_tex.pos=[-3,0,0]
gl_scene.entities.push(cube_tex)

cube_tex2 = Trogl::Object3d::CubeTex.new("../../data/pic/Stripes0007_S.jpg")
cube_tex2.pos=[3,0,0]
gl_scene.entities.push(cube_tex2)


# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )

gl_scene.bind_key(SDL::Key::A		, Proc.new {gl_scene.cam.straff(-0.2)} )
gl_scene.bind_key(SDL::Key::D		, Proc.new {gl_scene.cam.straff(0.2)} )
gl_scene.bind_key(SDL::Key::W		, Proc.new {gl_scene.cam.move_fw(0.2)} )
gl_scene.bind_key(SDL::Key::S		, Proc.new {gl_scene.cam.move_fw(-0.2)} )
gl_scene.bind_key(SDL::Key::SPACE		,Proc.new {gl_scene.cam.move_up(0.2)} )

gl_scene.bind_key(SDL::Key::T			,Proc.new {} )
gl_scene.bind_key(SDL::Key::UP			,Proc.new {} )
gl_scene.bind_key(SDL::Key::DOWN		,Proc.new {} )
gl_scene.bind_key(SDL::Key::PAGEUP		,Proc.new {} )
gl_scene.bind_key(SDL::Key::PAGEDOWN	,Proc.new {} )

gl_scene.bind_key_toggle(SDL::Key::TAB	,Proc.new {gl_scene.toggle_mouse_grab} )

mouse_callback = Proc.new do |event|
	if ( (event.x==50) && (event.y==50) )
		#puts "ignored #{event.inspect}"
	else
		gl_scene.cam.rot_x(event.yrel/200.0)
		gl_scene.cam.rot_vert(-event.xrel/200.0)
		
		SDL::Mouse.warp(50,50) if ( gl_scene.mouse_grab ) # that stupid mouse warp generates ans SDL::Event2::MouseMotion .... have to ignore it somehow ...
	end
end

gl_scene.bind_mouse(mouse_callback)
#SDL::WM::grab_input(SDL::WM::GRAB_ON)
#SDL::Mouse.show
gl_scene.draw_axis=true

gl_scene.start {}

