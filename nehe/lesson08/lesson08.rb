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
					:filter,	:blended
								
	def initialize
		@x_rot = @y_rot = 0.0
		@z = 5
		@x_speed = 0.01
		@y_speed = 0.02
	
		@tex_file = "glass.bmp"
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
		glPushMatrix()
		
		glTranslate(0, 0, @z)

		glRotate(@x_rot,1.0,0.0,0.0)
		glRotate(@y_rot,0.0,1.0,0.0)

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
		glPopMatrix()
	end
end

# creates a new gl scene  800x600 screen size with a fov of 70
gl_scene = Trogl::Scene.new(800,600,70,".oO[ trogl/ruby Nehe Lesson 08 - e4rache ]Oo.")
gl_scene.light.on=true

cube = NeheCube.new()
gl_scene.entities.push(cube)

# key bindings
gl_scene.bind_key(SDL::Key::Q			,Proc.new { exit } )
gl_scene.bind_key(SDL::Key::PAGEUP		,Proc.new { cube.z+=0.02 } )
gl_scene.bind_key(SDL::Key::PAGEDOWN	,Proc.new { cube.z-=0.02} )
gl_scene.bind_key(SDL::Key::LEFT		,Proc.new {cube.y_speed-=0.01} )
gl_scene.bind_key(SDL::Key::RIGHT		,Proc.new {cube.y_speed+=0.01} )
gl_scene.bind_key(SDL::Key::UP			,Proc.new {cube.x_speed+=0.01} )
gl_scene.bind_key(SDL::Key::DOWN		,Proc.new {cube.x_speed-=0.01} )
gl_scene.bind_key_toggle(SDL::Key::B	,Proc.new {cube.blended = !cube.blended? } )
gl_scene.bind_key_toggle(SDL::Key::F	,Proc.new { cube.filter+=1 } )
gl_scene.bind_key_toggle(SDL::Key::L	,Proc.new { gl_scene.lighting = !gl_scene.lighting? } )


# sets the camera position ( point of view )
gl_scene.cam.pos = ([0,0,0])

gl_scene.light.ambient = [0.5,0.5,0.5,1.0]
gl_scene.light.diffuse = [1.0,1.0,1.0,1.0]
gl_scene.light.pos = [4,4,2,1]

# start the main loop of the scene giving it a block to execute after each frame is rendered
gl_scene.start do
	cube.x_rot += cube.x_speed
	cube.y_rot += cube.y_speed
end

