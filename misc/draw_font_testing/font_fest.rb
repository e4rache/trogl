#!/usr/bin/env ruby

require "../../lib/trogl.rb"

class FontDrawer
	attr_accessor	:text

	def initialize(font_file="256BYTES.TTF")
		font_size = 20
		@font = FTGL::PolygonFont.new(font_file)
		#@font = FTGL::ExtrdFont.new(font_file)
		@font.SetFaceSize(font_size)
		res = @font.BBox("w00t")
		p res
		@alpha=0
		@beta=1.6175
		@draw_method_index = 0
		@draw_methods = [:unroll,:untwist,:scale]
		
		#@draw_methods = [:sin_scroll]
		@current_draw_method = method @draw_methods[@draw_method_index]
	end

	def draw
		glMatrixMode(GL_MODELVIEW)
		glColor(1,1,1,1)
		glPushMatrix
		#glLoadIdentity # this would reset camera
		glTranslate(0,0,0)
		glScale(0.3,0.3,0.3)
		glPopMatrix
		@current_draw_method.call("Cordyceps Fungus - The mind-control Killer-Fungi")
	end

	def next_draw_method
		@draw_method_index+=1
		@current_draw_method = method @draw_methods[@draw_method_index]
	end

	def sin_scroll(text)
		glPushMatrix
		glScale(0.2,0.2,0.2)
		ro=0
		text.scan(/./).each do |char|
			
		end
	end

	def scale(text)
		glPushMatrix
		glScale(0.2,0.2,0.2)
		ro = 0.0
		text.scan(/./).each do |char|
			if char != " "
				box = @font.BBox(char)
				glTranslate(box[3],0,0)
				glScale(1+Math.cos(@beta+ro)/20, 1+Math.cos(@beta+ro)/20, 1)
				@font.Render(char)
			else
				glTranslate(6,0,0)
			end
			ro+=0.2
		end
		@beta+=0.1
		glPopMatrix
	end

	def untwist(text)
		glPushMatrix
		#glTranslate(0,0,0)
		glScale(0.2,0.2,0.2)
		text.scan(/./).each do |char|
			#puts "char = #{char.inspect}"
			if char != " " 
			box = @font.BBox(char)
			glRotate(Math.sin(@beta)*100,1,0,0)
			@beta-=0.0001
			@font.Render(char)
			glTranslate(box[3],0,0)
			else
				glTranslate(6,0,0)
			end
		end
		glPopMatrix

		if @beta <= 0
			p "switching from untwist"
			@beta=Math::PI / 2
			next_draw_method
		end
	end

	def unroll(text)		
		p @beta
		glPushMatrix
		glTranslate(0,0,0)
		glScale(0.2,0.2,0.2)
		text.scan(/./).each do |char|
			if char != " " 	
				box = @font.BBox(char)
				#glRotate(Math.sin(@alpha)*4,0,0,1)
				glRotate(Math.cos(@beta+1.57059)*40,0,0,1)
				@beta-=0.0001
				@font.Render(char)
				glTranslate(box[3],0,0)
			else
				glTranslate(6,0,0)
			end
		end
		glPopMatrix
		if @beta <= 0
			p "switching from test"
			@beta=Math::PI
			next_draw_method
		end
	end

end


g = Trogl::Scene.new({:width => 1200, :height => 700, :caption => ".oO Trogl Oo.", :fov => 70 })	# create window ( width, height, fov )
# sets some params in trogl
#g.draw_axis=true
g.target_fps=30

# hud - show fps
hud = Trogl::Hud::BasicHud.new("256BYTES.TTF")
g.hud_entities.push(hud)

# some key bindings
anim_obj = g.cam

g.bind_key(SDL::Key::UP		, Proc.new {g.cam.move_up(0.2)} )
g.bind_key(SDL::Key::DOWN	, Proc.new {g.cam.move_up(-0.2)} )

g.bind_key(SDL::Key::A		, Proc.new {g.cam.straff(-0.2)} )
g.bind_key(SDL::Key::D		, Proc.new {g.cam.straff(0.2)} )
g.bind_key(SDL::Key::W		, Proc.new {g.cam.move_fw(0.2)} )
g.bind_key(SDL::Key::S		, Proc.new {g.cam.move_fw(-0.2)} )
g.bind_key(SDL::Key::SPACE   ,Proc.new {g.cam.move_up(0.2)} )

g.bind_key(SDL::Key::Q      , Proc.new { exit } )

g.bind_key_toggle(SDL::Key::M		, Proc.new {g.lighting = !g.lighting? } )
#g.bind_key(SDL::Key::F4		, Proc.new {anim_obj = } )

# proc for mouse_event processing

mouse_callback = Proc.new do |event|
	if ( (event.x==50) && (event.y==50) )
	else
		g.cam.rot_x(event.yrel/200.0)
		g.cam.rot_vert(-event.xrel/200.0)
		SDL::Mouse.warp(50,50) ## that stupid mouse warp generates ans SDL::Event2::MouseMotion .... have to ignore it somehow ...
	end
end
g.bind_mouse(mouse_callback)

#SDL::Mouse.hide
#g.bg_color=[0.2,0.2,0.2,0.0]
g.light.on=true
g.lighting=true

g.cam.front=Vec.new([0,0,-1])
g.cam.up=Vec.new([0,1,0])
g.cam.pos=([45,5,50])


fd=FontDrawer.new()
fd.text="w00t"
g.entities.push(fd)
g.start do
	hud.current_fps = g.current_fps.to_i
	hud.lighting = g.lighting?
end
