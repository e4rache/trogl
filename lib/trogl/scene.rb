=begin
	Trogl. Tiny Ruby OpenGL graphic engine
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
		attr_reader	:mouse_grab,	:current_fps
		attr_accessor	:window_width, :window_height, :entities, :hud_entities, :loop_callback,	:draw_axis, :cam, :light,	:lighting

		def initialize(w=200,h=200,f=90,caption="trogl")
			puts "Initializing Trogl ..."
			@draw_axis = false
			@target_fps = 30.0
			@fov=f
			
			@delay_fps = 1000.0 / @target_fps
			@entities = []
			@hud_entities = []
			@window_width = w
			@window_height = h
			@cycles=0
			
			# == cam
			@cam=Trogl::Math3d::Entity3d.new()
			@cam.pos=Vec.new([ 0,4,7])
			
			# == light
			@lighting = true
			glEnable(GL_LIGHTING)
			@light = Trogl::Light.new()

			# == window
			init_gl_window(@window_width,@window_height)
			SDL::WM.set_caption(caption,"")
			
			# == event manager
			@event_manager = Trogl::EventHandler::SdlEventManager.create()
			@event_manager.set_vid_resize_callback((method:reshape))
			
			# == grab mouse default
			#SDL::WM::grab_input(SDL::WM::GRAB_ON)
			#SDL::Mouse.hide
			@mouse_grab = true
			puts "Done."
		end
	
		def lighting?
			@lighting
		end

		def lighting=(lighting)
			lighting == true ? glEnable(GL_LIGHTING) : glDisable(GL_LIGHTING)
			@lighting = lighting
			puts " lighting = #{@lighting}"
		end

		def target_fps=(t_fps)
			@target_fps = t_fps
			@delay_fps = 1000.0 / @target_fps
		end

		def bind_key_toggle(key_sym,proc_to_bind)
			@event_manager.bind_key_toggle(key_sym, proc_to_bind)
		end

		def bind_key(key_sym, proc_to_bind )
			@event_manager.bind_key(key_sym , proc_to_bind )
		end

		def bind_mouse(proc_to_bind)
			@event_manager.bind_mouse(proc_to_bind)
		end

		def toggle_mouse_grab
			@mouse_grab = ! @mouse_grab
			if ( @mouse_grab )
				p "grab ON"
				SDL::WM::grabInput(SDL::WM::GRAB_ON)
				#SDL::Mouse.hide
				#p SDL::WM::grab_input(SDL::WM::GRAB_QUERY)
			else
				p "grab OFF"
				SDL::WM::grabInput(SDL::WM::GRAB_OFF) # FIX ME - seems there's a bug in ruby-sdl, this doesn't work as supposed to.
				SDL::Mouse.show
			end
		end
		
		def bg_color=(bg_color)
			 glClearColor(bg_color[0],bg_color[1],bg_color[2],bg_color[3])
		end

		def start(&block)
			@started=true
			@event_manager.clear_event_queue()
			t_initial = SDL.get_ticks()
			frames = 0
			
			loop do
				t0 = SDL.get_ticks()
				
				main_loop()
				block.call()
				
				t1 = SDL.get_ticks()
				delay = @delay_fps+t0-t1	# delay to meet target_fps
				SDL.delay(delay) if delay>10 

				# compute fps 
				frames+=1
				if ( t1 - t_initial > 5000 )
					seconds = (t1 - t_initial)/1000.0
					fps = frames / seconds
					@current_fps = fps
					puts " FPS: #{fps} "
					t_initial = t1
					frames = 0
				end
			end
		end

		private

		def main_loop()
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
			glFlush
			glFinish
			SDL.GLSwapBuffers
		end

		def draw_gl_scene

			# put cam
			# gluLookAt(0,2,5, 0,0,0, 0,1,0) - ( pos3f , point3d, up3f )	
			gluLookAt(
				@cam.pos[0], @cam.pos[1], @cam.pos[2], 			#position
				@cam.pos[0]+@cam.front[0], @cam.pos[1]+@cam.front[1], @cam.pos[2]+@cam.front[2],  # looking at
			# 	0,0,0,
				@cam.up[0], @cam.up[1], @cam.up[2] 
			#	0,1,0
			
			)			# up vector
	
			
			update_lights() if @light.on?
			
			# put entities
			Trogl::Object3d::Axis.draw() if @draw_axis

			@entities.each { |ent| ent.draw() }

			@hud_entities.each do |hud_ent|
				hud_draw { hud_ent.draw }
			end
			#glMatrixMode(GL_MODELVIEW)
		end

		def hud_draw(&hud_entity_draw_method)
			glMatrixMode(GL_PROJECTION)
			glPushMatrix
			glLoadIdentity()
			glOrtho(0,1000,1000,0,-1,1)
			glMatrixMode(GL_MODELVIEW)
			glPushMatrix
			glLoadIdentity
			glDisable(GL_LIGHTING) if lighting?

			hud_entity_draw_method.call()
			
			glEnable(GL_LIGHTING) if lighting?
			glPopMatrix
			glMatrixMode(GL_PROJECTION)
			glPopMatrix()
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

		def update_lights()
			position = @light.pos
			ambient = @light.ambient
			mat_diffuse = @light.diffuse
			mat_specular = @light.specular
			mat_shininess = @light.shininess

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
			SDL.init(SDL::INIT_VIDEO | SDL::INIT_EVENTTHREAD )
			SDL.set_GL_attr(SDL::GL_DOUBLEBUFFER,1)
			SDL.set_video_mode(w, h, 0, SDL::RESIZABLE|SDL::OPENGL|SDL::HWSURFACE)
		end

		def init_gl
		    glClearColor(0.16,0.16,0.16,0.0)
		    glClearDepth(1.0)
		    glEnable(GL_DEPTH_TEST)
			glDepthFunc(GL_LEQUAL)
			glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST )
			glEnable(GL_TEXTURE_2D)
			glEnable(GL_COLOR_MATERIAL)
		    glShadeModel(GL_SMOOTH)
			glColor4f( 1.0, 1.0, 1.0, 0.5)
			glBlendFunc( GL_SRC_ALPHA, GL_ONE )
		end
	end
end
