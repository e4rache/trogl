#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"

include Gl
include Glu

require "../../lib/trogl.rb" # our Tiny Ruby OpenGL 3d graphic engine framework

class NeheCube
	
	attr_accessor	:x_rot,	:y_rot,	:z,
					:x_speed,	:y_speed,
					:filter,	:blended,
					:gap			
	def initialize
		@x_rot = @y_rot = 0.0
		@z = 4.36
		@x_speed = 2.24
		@y_speed = -2.44
	
		@gap = 0.07

		@tex_file = "star.bmp"
		init_tex()
		@filter = 2 # new
		
		@blended = true

		# cube data : tex coords, vertices, faces, normals
		@tex_coords = [
				[0,0],
				[0,1],
				[1,1],
				[1,0]
			]

		@faces = [
	    		[ #top face
	        		[ 1.0,  1.0, -1.0],
			        [-1.0,  1.0, -1.0],
			        [-1.0,  1.0,  1.0],
			        [ 1.0,  1.0,  1.0],
					[0,1,0] # normal
				],
				[  # bottom face
					[ 1.0, -1.0,  1.0],
					[-1.0, -1.0,  1.0],
			        [-1.0, -1.0, -1.0],
			        [ 1.0, -1.0, -1.0],
					[0,-1,0] # normal
				],
				[ #front face
		        	[ 1.0,  1.0,  1.0],
			        [-1.0,  1.0,  1.0],
			        [-1.0, -1.0,  1.0],
	        		[ 1.0, -1.0,  1.0],
					[0,0,1] # normal
				],
			    [ #back face
			        [1.0, -1.0, -1.0],
			        [-1.0, -1.0, -1.0],
			        [-1.0,  1.0, -1.0],
			        [ 1.0,  1.0, -1.0],
					[0,0,-1] #normal
				],
			    [ #left face
			        [-1.0,  1.0,  1.0],
			        [-1.0,  1.0, -1.0],
			        [-1.0, -1.0, -1.0],
			        [-1.0, -1.0,  1.0],
					[-1,0,0] # normal
				],
			    [ #right face
			        [ 1.0,  1.0, -1.0],
			        [ 1.0,  1.0,  1.0],
			        [ 1.0, -1.0,  1.0],
			        [ 1.0, -1.0, -1.0],
					[1,0,0] # normal
			    ]
			]
			gen_display_list() # generate a display list for a single cube
	end
	
	def blended?
		@blended
	end

	def filter=(index)
		if index > 2 
			@filter = 0
		else
			@filter = index
		end
		puts "filter = #{filter}"
	end


	def init_tex
		surface = SDL::Surface.load(@tex_file)

		@texture = glGenTextures(3)	# building 3 textures this time.

		# tex 1 - GL_NEAREST

		glBindTexture(GL_TEXTURE_2D, @texture[0])
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
		glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB,GL_UNSIGNED_BYTE, surface.pixels)
		
		# tex 2 - GL_LINEAR
		
		glBindTexture(GL_TEXTURE_2D, @texture[1])
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB,GL_UNSIGNED_BYTE, surface.pixels)

		# tex 3 - Mipmapped
		
		glBindTexture(GL_TEXTURE_2D, @texture[2])
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
		                     GL_LINEAR_MIPMAP_NEAREST )
		glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
							GL_LINEAR );
		gluBuild2DMipmaps( GL_TEXTURE_2D, 3, surface.w, surface.h, GL_RGB,GL_UNSIGNED_BYTE, surface.pixels)

		surface = nil
	end

	# will be called by the main loop of Trogl:Scene. see below.
	def draw
		if ( @blended ) 
			glEnable( GL_BLEND );
			glDisable( GL_DEPTH_TEST );
		else
			glDisable( GL_BLEND );
			glEnable( GL_DEPTH_TEST );
		end
		
		glMatrixMode(GL_MODELVIEW)
		0.upto(4) do |k|
			kgap = k*@gap
			0.upto(4) do |j|
				jgap = j*@gap
				0.upto(2) do |i|
					glPushMatrix()	
					glTranslate(jgap,kgap, @z+i+@gap)
					glRotate(@x_rot,1.0,0.0,0.0)
					glRotate(@y_rot,0.0,1.0,0.0)
					r=k/10.0
					g=j/10.0
					b=i/10.0
					glColor(r,g,b,0.2)
					glCallList(@display_list)
					glPopMatrix()
				end
			end
		end
	end

	def gen_display_list
		@display_list = glGenLists(1)
		glNewList(@display_list,GL_COMPILE)
		glBindTexture(GL_TEXTURE_2D, @texture[@filter] )  # new
		glBegin(GL_QUADS)
		@faces.each { |vertices|
			glNormal(vertices.last)
			tex_point_index = 0
			vertices[0..3].each { |vertex|
				glTexCoord(@tex_coords[tex_point_index])
				tex_point_index = ( tex_point_index +1 )
				glVertex3fv(vertex)
			}
		}
		glEnd()
		glEndList()
	end
end

# creates a new gl scene  800x600 screen size with a fov of 70
gl_scene = Trogl::Scene.new(800,600,80,".oO[ trogl/ruby moded Nehe Lesson 08 Oo.")
gl_scene.light.on=true

cube = NeheCube.new()
gl_scene.entities.push(cube)

# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )
gl_scene.bind_key(SDL::Key::PAGEUP		,Proc.new { cube.z+=0.02 } )
gl_scene.bind_key(SDL::Key::PAGEDOWN	,Proc.new { cube.z-=0.02} )
gl_scene.bind_key_toggle(SDL::Key::F			,Proc.new { cube.filter+=1 } )
gl_scene.bind_key_toggle(SDL::Key::L			,Proc.new { gl_scene.lighting = !gl_scene.lighting? } )
gl_scene.bind_key(SDL::Key::LEFT		,Proc.new {cube.y_speed-=0.02} )
gl_scene.bind_key(SDL::Key::RIGHT		,Proc.new {cube.y_speed+=0.02} )
gl_scene.bind_key(SDL::Key::UP			,Proc.new {cube.x_speed+=0.02} )
gl_scene.bind_key(SDL::Key::DOWN		,Proc.new {cube.x_speed-=0.02} )
gl_scene.bind_key_toggle(SDL::Key::B			,Proc.new {cube.blended = !cube.blended? } )

gl_scene.bind_key(SDL::Key::A		, Proc.new {gl_scene.cam.straff(-0.2)} )
gl_scene.bind_key(SDL::Key::D		, Proc.new {gl_scene.cam.straff(0.2)} )
gl_scene.bind_key(SDL::Key::W		, Proc.new {gl_scene.cam.move_up(0.2)} )
gl_scene.bind_key(SDL::Key::S		, Proc.new {gl_scene.cam.move_up(-0.2)} )
gl_scene.bind_key(SDL::Key::O		, Proc.new {cube.gap+=0.01} )
gl_scene.bind_key(SDL::Key::L		, Proc.new {cube.gap-=0.01} )


gl_scene.cam.pos = ([0.4,0.4,0])

gl_scene.light.ambient = [0.5,0.5,0.5,1.0]
gl_scene.light.diffuse = [1.0,1.0,1.0,1.0]
gl_scene.light.pos = [4,4,2,1]

gl_scene.start do
	cube.x_rot += cube.x_speed
	cube.y_rot += cube.y_speed
#	puts "#{cube.x_speed} - #{cube.y_speed} - #{cube.gap} -#{cube.z}"
#	puts "#{gl_scene.cam.pos}"
end

