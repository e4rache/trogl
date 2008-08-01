#!/usr/bin/env ruby

=begin
	.3ds object loader.
	3ds file structure can be found at http://www.martinreddy.net/gfx/3d/3DS.spec
=end

module Loader3ds

	CHUNCK_MAIN			= 0x4d4d
	CHUNCK_EDITOR		= 0x3d3d
	CHUNCK_OBJECT		= 0x4000
	CHUNCK_TRIMESH		= 0x4100
	CHUNCK_TRIVERTEX	= 0x4110
	CHUNCK_TRIFACE		= 0x4120
	
	class Object3ds
		def initialize(file_name)
		end
	end
	
end
