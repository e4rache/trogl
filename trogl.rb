=begin
	Trogl. Tiny Ruby OpenGL (Environment)
=end

require "gl"
require "glu"
require "sdl"
require "objects/axis.rb"


require "mathn"

include Gl
include Glu

require 'event_handler/sdl_event_manager.rb'

class Trogl
	attr_accessor	:window_width, :window_height, :cam_angle, :entities, :loop_callback,	:draw_axis

	def initialize(w=800,h=600,f=90)
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
		
		init_gl_window(@window_width,@window_height)
		@eventManager = SdlEventManager.create()
		@eventManager.set_vid_resize_callback((method:reshape))
		
		puts "Done."
	end

	def target_fps=(t_fps)
		@target_fps = t_fps
		@delay_fps = 1000.0 / @target_fps
	end

	def bind_key(key_sym, proc_to_bind )
		@eventManager.bind_key(key_sym , proc_to_bind )
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
			@eventManager.process_events()
			@eventManager.exec_key_pressed()
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

		SDL.GLSwapBuffers

	end

	def draw_gl_scene

		# put cam
		gluLookAt(0,2,5, 0,0,0, 0,1,0)		

		glRotate(@cam_angle, 0,1,0 )
		
		# put entities
		Axis.draw() if @draw_axis

		@entities.each { |ent|
			ent.draw()
		}
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

	def init_lights(pos=[0,5,10,1])
		position = pos
	    ambient = [0.7, 0.7, 0.7, 1.0]
	    mat_diffuse = [0.8, 0.8, 0.8, 1.0]
	    mat_specular = [1.0, 1.0, 1.0, 1.0]
    	mat_shininess = [70.0]

	    glEnable(GL_LIGHTING)
	    glEnable(GL_LIGHT0)
	
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

