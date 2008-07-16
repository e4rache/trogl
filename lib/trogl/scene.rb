=begin
	Trogl. Tiny Ruby OpenGL (Environment)
=end

require "gl"
require "glu"
require "sdl"

require "mathn"

include Gl
include Glu

require 'trogl/event_handler/sdl_event_manager.rb'
require "trogl/object3d/axis.rb"

module Trogl
	class Scene
		attr_accessor	:window_width, :window_height, :cam_angle, :entities, :loop_callback,	:draw_axis, :cam

		def initialize(w=200,h=200,f=90,caption="trogl")
			puts "Initializing Trogl ..."
			@draw_axis = true
			@target_fps = 30.0
			@delay_fps = 1000.0 / @target_fps
			@entities = []
			@cam_angle=0.0
			@window_width = w
			@window_height = h
			@fov=f
			@cycles=0
			@cam=Trogl::Math3d::Entity3d.new()
			@cam.pos=[ 5,5,5 ]
			init_gl_window(@window_width,@window_height)
			SDL::WM.set_caption(caption,"")
			@event_manager = SdlEventManager.create()
			@event_manager.set_vid_resize_callback((method:reshape))
			puts "Done."
		end

	def target_fps=(t_fps)
		@target_fps = t_fps
		@delay_fps = 1000.0 / @target_fps
	end

	def bind_key(key_sym, proc_to_bind )
		@event_manager.bind_key(key_sym , proc_to_bind )
	end

	def bind_mouse(proc_to_bind)
		@event_manager.bind_mouse(proc_to_bind)
	end

	def start(&block)
		loop do
			t0 = SDL.get_ticks()
			main_loop()
			block.call()
			t1 = SDL.get_ticks()
			delay = @delay_fps+t0-t1
			SDL.delay(delay) if delay>10
		end
	end

	private

	def main_loop()
			@cycles+=1
			@event_manager.process_events()
			@event_manager.exec_key_pressed()
			draw_and_swap
	end

	# =====================================
	#	Scene draw 
	# =====================================

	def draw_and_swap
	
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	    glMatrixMode(GL_MODELVIEW)
		glLoadIdentity
		glColor3f(1.0,1.0,1.0)
		
		draw_gl_scene

		#
		SDL::TTF.init
		font = SDL::TTF.open("data/ft/verdana.ttf",12)
		s = SDL.get_video_surface
		font.draw_solid_utf8(s,"Bleaargh",10,10,255,255,255)
		#

		SDL.GLSwapBuffers

	end

	def draw_gl_scene

		# put cam
		#gluLookAt(0,2,5, 0,0,0, 0,1,0)		
		gluLookAt(
			@cam.pos[0], @cam.pos[1], @cam.pos[2], 			#position
			@cam.pos[0]+@cam.front[0], @cam.pos[1]+@cam.front[1], @cam.pos[2]+@cam.front[2],  # looking at
			@cam.up[0], @cam.up[1], @cam.up[2] )			# up vector

		#glRotate(@cam_angle, 0,1,0 )
	
		update_lights

		# put entities
		Axis.draw() if @draw_axis

		@entities.each { |ent| ent.draw() }

	end


	# =====================================
	#	Gl init and Lighting
	# =====================================


	def init_gl_window(width =200, height = 200)
		init_sdl(width,height)
		init_gl
		reshape(width, height)
	end
	
	def reshape(width = 200, height = 200 )
		SDL.set_video_mode(width, height, 0, SDL::RESIZABLE|SDL::OPENGL|SDL::HWSURFACE)
		puts "reshape called with params : " + width.to_s + " | " + height.to_s + " | " + @fov.to_s
		#height = height < 1 ? 1 : height
		glViewport(0, 0, width, height)
		glMatrixMode(GL_PROJECTION)
		glLoadIdentity
		gluPerspective(@fov, width / height, 0.1, 100.0)
		glMatrixMode(GL_MODELVIEW)
	end

	def init_lights(pos=[2,5,10,1])
		glEnable(GL_LIGHTING)
		glEnable(GL_LIGHT0)
		update_lights(pos=[2,5,10,1])
	end

	def update_lights(pos=[2,5,10,1])

		position = pos	
		ambient = [0.2, 0.2, 0.2, 1.0]
		mat_diffuse = [0.6, 0.6, 0.6, 1.0]
		mat_specular = [1.0, 1.0, 1.0, 1.0]
		mat_shininess = [50.0]

=begin
	  	ambient = [0.2, 0.1, 0.1, 1.0]
	    mat_diffuse = [0.8, 0.8, 0.8, 1.0]
	    mat_specular = [1.0, 1.0, 1.0, 1.0]
	   	mat_shininess = [100.0]
=end
		glLight(GL_LIGHT0, GL_AMBIENT, ambient)
		glLight(GL_LIGHT0, GL_POSITION, position)	

	    glMaterial(GL_FRONT, GL_DIFFUSE, mat_diffuse)
	    glMaterial(GL_FRONT, GL_SPECULAR, mat_specular)
	    glMaterial(GL_FRONT, GL_SHININESS, mat_shininess)
	end

	def init_sdl(w,h)
		SDL.init(SDL::INIT_VIDEO)
		SDL.set_GL_attr(SDL::GL_DOUBLEBUFFER,1)
		SDL.set_video_mode(w, h, 0, SDL::RESIZABLE|SDL::OPENGL|SDL::HWSURFACE)
	end

		def init_gl
		    glClearColor(0.0, 0.0, 0.0, 0)
		    glClearDepth(1.0)
		    glDepthFunc(GL_LEQUAL)
			glEnable(GL_TEXTURE_2D)
		    glEnable(GL_DEPTH_TEST)
			glEnable(GL_COLOR_MATERIAL)
		    glShadeModel(GL_SMOOTH)
			init_lights
		end
	end
end
