$:.unshift File.dirname(__FILE__) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Trogl
	module Math3d
		module Alg3d
		end
	end
	module Object3d
		module Loader
		end
	end
end


require 'trogl/math3d.rb'
require 'trogl/event_handler.rb'
require 'trogl/scene.rb'
require 'trogl/object3d.rb'
