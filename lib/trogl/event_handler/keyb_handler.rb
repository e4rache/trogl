class KeyState
	attr_accessor	:id , :pressed, :toggled, :bound_proc

	def initialize(id)
		@id = id
		@pressed=false
		@toggled=false
		@bound_proc=nil
		@bound=false
	end

	def pressed?
		@pressed
	end

	def bound?
		@bound
	end

	def bind!(method)
		@bound_proc = method
		@bound=true
	end

	def unbind!
		@bound_proc=nil
		@bound=false
	end
end

class KeybHandler
	private_class_method :new	
	@@instance = nil
	
	@@key_table = Hash.new

	def self.create
		@@instance = new unless @@instance
		@@instance
	end

	def initialize()
		# FIX ME : s/500/max(key_id in sdl)
		(0..500).each do |i|
			@@key_table[i] = KeyState.new(i)
		end
	end
	
	def key(key_id)
		@@key_table[key_id]
	end

	def key_status(key_id)
		@@key_table[key_id].pressed?
	end
	alias :key_pressed? :key_status

	def update_key_state(key_id, key_state)
		@@key_table[key_id].pressed = key_state
	end
	
	def bind_key(key_id, method)
		@@key_table[key_id].bind!(method)
	end

	def methods_to_exec()
		methods = []
		@@key_table.each do |k|
			if k[1].pressed?
				if k[1].bound?
					methods.push(k[1].bound_proc)		
				end
			end
		end
		methods
	end
end
