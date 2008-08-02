#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"

include Gl
include Glu

require "../../lib/trogl.rb" 

class Flag		
	
	attr_accessor	:wiggle_count, :x_rot, :y_rot, :z_rot

	def initialize
		@wiggle_count=0
		@x_rot=0
		@y_rot=0
		@z_rot=0
		
		@points=[]
		@tex_coords=[]
		# generate the points of the flag ( 45x45 )
		0.upto(44) do |x|
			@points[x]=[]
			@tex_coords[x]=[]
			0.upto(44) do |y|
				@points[x][y]=
					[ (x/5.0)-4.5 , (y/5.0)-4.4 , Math.sin( ((x/5.0)*40.0/360.0)  * Math::PI * 2.0 ) ]
				@tex_coords[x][y]=[
					tex_x = x/44.0,
					tex_y = y/44.0,
					tex_xb = (x+1)/44.0,
					tex_yb = (y+1)/44.0,
					]

			end
		end
		#create the texture
		@tex_file = "tim.bmp"
		init_tex()
		glPolygonMode( GL_BACK, GL_FILL );
		glPolygonMode( GL_FRONT, GL_LINE );
		@range_0_43 = (0..43)
	end

	def draw
		glPushMatrix
		glLoadIdentity
		glTranslate(0.0, 0.0, -12.0)
		glRotate(@x_rot, 1.0, 0.0, 0.0 )
		glRotate(@y_rot, 0.0, 1.0, 0.0 )
		glRotate(@z_rot, 0.0, 0.0, 1.0 )

		glBindTexture(GL_TEXTURE_2D, @textures[0])
		glBegin(GL_QUADS)
		x=0
		while(x<44)
			y=0
			while(y<44)
					tex_x = @tex_coords[x][y][0]
					tex_y = @tex_coords[x][y][1]
					tex_xb = @tex_coords[x][y][2]
					tex_yb = @tex_coords[x][y][3]

					glTexCoord( tex_x, tex_y)
					#puts " point x.y #{@points[x][y]}"
					glVertex( @points[x][y] )

					glTexCoord( tex_x, tex_yb)
					glVertex( @points[x][y+1] )

					glTexCoord( tex_xb, tex_yb)
					glVertex( @points[x+1][y+1] )

					glTexCoord( tex_xb, tex_y )
					glVertex( @points[x+1][y] )
				y+=1
			end
			x+=1
		end
		glEnd
		glPopMatrix
		if ( @wiggle_count == 2 )
			y=0
			while (y<45)
				hold = @points[0][y][2]
				x = 0
				while ( x<44 )
					@points[x][y][2] = @points[x+1][y][2]
					x+=1
				end
				@points[44][y][2] = hold
				y+=1
			end
			@wiggle_count = 0
		end
		@wiggle_count+=1

		@x_rot += 0.3
		@y_rot += 0.2
		@z_rot += 0.4
	end

	def init_tex
		surface = SDL::Surface.load(@tex_file)
		@textures = glGenTextures(1)
		glBindTexture(GL_TEXTURE_2D, @textures[0])
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_BGR,GL_UNSIGNED_BYTE, surface.pixels)
		surface = nil
	end

end


# creates a new gl scene  800x600 screen size with a fov of 70
gl_scene = Trogl::Scene.new({:width => 800,:height => 600, :fov => 70, :caption => ".oO[ trogl/ruby Nehe Lesson 11 - e4rache ]Oo."})
gl_scene.light.on=true
gl_scene.target_fps=600

flag = Flag.new()
gl_scene.entities.push(flag)

# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )
gl_scene.bind_key(SDL::Key::T			,Proc.new { } )
gl_scene.bind_key(SDL::Key::UP			,Proc.new {} )
gl_scene.bind_key(SDL::Key::DOWN		,Proc.new {} )
gl_scene.bind_key(SDL::Key::PAGEUP		,Proc.new {} )
gl_scene.bind_key(SDL::Key::PAGEDOWN	,Proc.new {} )

gl_scene.start {}

