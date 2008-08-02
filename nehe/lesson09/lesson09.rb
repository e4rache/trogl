#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"

include Gl
include Glu

require "../../lib/trogl.rb" 

class Star
	attr_accessor 	:r, :g, :b, 
					:dist,
					:angle,
					:id
	def initialize(id)
		@id = id
		@angle=0.0
		@dist=0;
		@r = rand
		@g = rand
		@b = rand
	end
end

class Stars < Array
	attr_accessor	:twinkle,	:zoom,	:tilt,	:loop,	:textures,
					:status,	:spin
	
	STAR_NUM = 50

	def initialize
		super
		@zoom = -15.0
		@tilt = 90.0
		@spin = 0;
		@tex_file = "star.bmp"
		init_tex()

		#init starts
		0.upto(STAR_NUM - 1) do |i|
			self[i]= Star.new(i)
			self[i].dist = ( i *1.0 / STAR_NUM)  * 5.0;
		end
	end

	# load texture for the stars
	def init_tex
		surface = SDL::Surface.load(@tex_file)
		@textures = glGenTextures(1)
		glBindTexture(GL_TEXTURE_2D, @textures[0])
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB,GL_UNSIGNED_BYTE, surface.pixels)
		surface = nil
	end

	def draw
		glBlendFunc(GL_SRC_ALPHA,GL_ONE)
		glEnable(GL_BLEND)
		glDisable(GL_DEPTH_TEST)
		
		glBindTexture( GL_TEXTURE_2D, @textures[0])
		glLoadIdentity
		self.each do |star|
			glLoadIdentity
			glTranslate(0.0,0.0,@zoom)
			glRotate(@tilt,1.0,0.0,0.0)
			glRotate(star.angle,0.0,1.0,0.0)
			glTranslate(star.dist,0.0,0.0)
			glRotate(-star.angle,0.0,1.0,0.0)
			glRotate(-tilt,1.0,0.0,0.0)
			if ( @twinkle )
				glColor(1.0,1.0,1.0,0.8)
				glBegin(GL_QUADS)
					glTexCoord(0,0)
					glVertex(-1.0,-1.0,0.0)
					glTexCoord(1.0, 0.0)
					glVertex(1.0, -1.0, 0.0)
					glTexCoord(1.0, 1.0)
					glVertex(1.0, 1.0, 0.0)
					glTexCoord(0.0,1.0)	
					glVertex(-1,1,0)
				glEnd
			end
			# Main star
			glRotate(@spin, 0.0, 0.0, 1.0 );
			glColor( star.r, star.g,star.b,0.8 )
			glBegin(GL_QUADS)
				glTexCoord(0,0)
				glVertex(-1.0, -1.0, 0.0)
				glTexCoord(1.0, 0.0)
				glVertex(1.0, -1.0, 0.0)
				glTexCoord(1.0, 1.0)
				glVertex(1.0, 1.0, 0.0)
				glTexCoord(0.0,1.0)
				glVertex(-1,1,0)
			glEnd

			@spin += 0.01
			star.angle += (star.id * 1.0) / STAR_NUM
			star.dist -= 0.01 
				
			if ( star.dist < 0.0 )
				star.dist+=5
				star.r=rand
				star.g=rand
				star.b=rand
			end
		end
	end
end

# creates a new gl scene  800x600 screen size with a fov of 70
gl_scene = Trogl::Scene.new({:width => 800,:height => 600, :caption => ".oO[ trogl/ruby Nehe Lesson 09 - e4rache ]Oo.", :fov => 70 })
gl_scene.light.on=true

stars = Stars.new()
gl_scene.entities.push(stars)

# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )
gl_scene.bind_key_toggle(SDL::Key::T			,Proc.new {stars.twinkle=!stars.twinkle } )
gl_scene.bind_key(SDL::Key::UP			,Proc.new {stars.tilt+=0.5} )
gl_scene.bind_key(SDL::Key::DOWN		,Proc.new {stars.tilt-=0.5} )
gl_scene.bind_key(SDL::Key::PAGEUP		,Proc.new {stars.zoom+=0.2} )
gl_scene.bind_key(SDL::Key::PAGEDOWN	,Proc.new {stars.zoom-=0.2} )


gl_scene.target_fps=100
gl_scene.start {}


