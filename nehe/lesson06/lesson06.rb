#!/usr/bin/env ruby

require "gl"
require "glu"
require "sdl"

include Gl
include Glu

require "../../lib/trogl.rb" # our Tiny Ruby OpenGL 3d graphic engine framework

class NeheCube
	
	attr_accessor	:x_rot,	:y_rot,	:z_rot

	def initialize
		@x_rot = @y_rot = @z_rot = 0
		
		@tex_file = "NeHe.bmp"
		init_tex()
		
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

	def init_tex
		surface = SDL::Surface.loadBMP(@tex_file)
		texture = glGenTextures(1)
		glBindTexture(GL_TEXTURE_2D, texture[0])
		glTexImage2D(GL_TEXTURE_2D, 0, 3, surface.w, surface.h, 0, GL_RGB,GL_UNSIGNED_BYTE, surface.pixels)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		surface = nil
		@texture_id = texture[0]
	end

	# will be called by the main loop of Trogl:Scene. see below.
	def draw
		glMatrixMode(GL_MODELVIEW)
		glPushMatrix()
		
		glColor(1,1,1)
	
		glTranslate(-3, 0, 10)

		glRotate(@x_rot,1.0,0.0,0.0)
		glRotate(@y_rot,0.0,1.0,0.0)
		glRotate(@z_rot,0.0,0.0,1.0)

		glBegin(GL_QUADS)
		@faces.each { |vertices|
			glNormal(vertices.last)
			tex_point_index = 0
			vertices[0..3].each { |vertex|
				glTexCoord(@tex_coords[tex_point_index])
				tex_point_index = ( tex_point_index +1 ) & 3
				glVertex3fv(vertex)
			}
		}
		glEnd()
		glPopMatrix()
	end
end

# creates a new gl scene  800x600 screen size with a fov of 70
gl_scene = Trogl::Scene.new(800,600,70,".oO Nehe Lesson 06 Oo.")

# instanciates the above Cube class definition.
cube = NeheCube.new()

# add the cube to the entities the scene has to draw
gl_scene.entities.push(cube)

# bin the 'q' key to quit the application
gl_scene.bind_key(SDL::Key::Q	,Proc.new { exit } )

# sets the camera position ( point of view )
gl_scene.cam.pos = ([-3,0,7.0])


#gl_scene.light_pos = ([2,5,5,1])


# start the main loop of the scene giving it a block to execute after each frame is rendered
gl_scene.start do
	cube.x_rot += 0.2 
	cube.y_rot += 0.2 
	cube.z_rot += 0.2
end

