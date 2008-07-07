require 'event_handler/keyb_handler.rb'
require 'sdl'

# ====================================
#	SDL event manager singleton
# ====================================

class SdlEventManager
	private_class_method :new
	@@instance = nil
	
	def SdlEventManager.create()
		@@instance = new unless @@instance
		@@instance
	end

	def initialize()
		puts "initializing event handler"
		@@keyb_handler = KeybHandler.create()
	end
	
	def process_events
		while event = SDL::Event2.poll
			case event
			
				# keyboards events
				when SDL::Event2::KeyDown
					exit if event.sym == SDL::Key::ESCAPE
					@@keyb_handler.update_key_state(event.sym,true)
				when SDL::Event2::KeyUp
					@@keyb_handler.update_key_state(event.sym,false)
				
				# quit event
				when SDL::Event2::Quit
					exit
				# window resize event
				when SDL::Event2::VideoResize
					# callback the reshape
					puts " vid reshape " + event.w.inspect + " | " + event.h.inspect
					@@vid_resize_callback.call(event.w,event.h) if @@vid_resize_callback != nil
			end
		end
		#SDL::Key.scan
	end

	def SdlEventManager.set_vid_resize_callback(callBack)
		@@vid_resize_callback = callBack
	end
	
	def set_vid_resize_callback(callBack)
		@@vid_resize_callback = callBack
	end

	def key_pressed?(key_id)
		@@keyb_handler.key_status(key_id)
	end
	
	def bind_key(sdl_key_sym,method)
		@@keyb_handler.bind_key(sdl_key_sym, method)	
	end

	def exec_key_pressed()
		arr = @@keyb_handler.methods_to_exec()
		arr.each { |method|
			method.call()
		}
	end
end
