#!/usr/bin/env ruby

require "lib/trogl.rb"

g = Trogl::Scene.new({ :width => 1200, :height => 700, :caption => ".oO Trogl Oo.", :fov => 70 })	# create window ( width, height, fov )

# create a textured cube and set it's position

cube_tex = Trogl::Object3d::CubeTex.new()
cube_tex.pos=[-3,0,0]

cube_tex_nehe_crate = Trogl::Object3d::CubeTex.new("data/pic/crate.jpg")
cube_tex_nehe_crate.pos=[0,0,0]

# load a wavefront object (.obj) with a scale factor
#wf_test = Trogl::Object3d::Loader::WaveFrontObject.new("data/obj/diatomee.obj",0.5)
wf_test = Trogl::Object3d::Loader::WaveFrontObject.new("data/obj/bone.obj",0.05)
#wf_test = Trogl::Object3d::Loader::WaveFrontObject.new("data/obj/spaceship.obj",0.05)
wf_test.pos=[3,1,0]

# sets some params in trogl
g.draw_axis=true
g.target_fps=30

# add the loaded objects to trogl
g.entities.push(cube_tex)
g.entities.push(wf_test)
g.entities.push(cube_tex_nehe_crate)

# hud - show fps
hud = Trogl::Hud::BasicHud.new()
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

g.bind_key(SDL::Key::U		, Proc.new {anim_obj.rot_x(0.04)} )
g.bind_key(SDL::Key::J		, Proc.new {anim_obj.rot_x(-0.04)} )
g.bind_key(SDL::Key::H		, Proc.new {anim_obj.rot_y(0.04)} )
g.bind_key(SDL::Key::K		, Proc.new {anim_obj.rot_y(-0.04)} )
g.bind_key(SDL::Key::B		, Proc.new {anim_obj.rot_z(-0.04)} )
g.bind_key(SDL::Key::N		, Proc.new {anim_obj.rot_z(0.04)} )
g.bind_key(SDL::Key::I		, Proc.new {anim_obj.move_fw(0.1)} )
g.bind_key(SDL::Key::L		, Proc.new {anim_obj.move_fw(-0.1)} )

g.bind_key_toggle(SDL::Key::M		, Proc.new {g.lighting = !g.lighting? } )
g.bind_key_toggle(SDL::Key::F1		, Proc.new {anim_obj = cube_tex} )
g.bind_key_toggle(SDL::Key::F2		, Proc.new {anim_obj = wf_test} )
g.bind_key_toggle(SDL::Key::F3		, Proc.new {anim_obj = g.cam } )
#g.bind_key(SDL::Key::F4		, Proc.new {anim_obj = } )

# proc for mouse_event processing

mouse_callback = Proc.new do |event|
	if ( (event.x==50) && (event.y==50) )
		#puts "ignored #{event.inspect}"
	else
		g.cam.rot_x(event.yrel/200.0)
		g.cam.rot_vert(-event.xrel/200.0)
		SDL::Mouse.warp(50,50) ## that stupid mouse warp generates ans SDL::Event2::MouseMotion .... have to ignore it somehow ...
	end
end
g.bind_mouse(mouse_callback)

#SDL::WM::grab_input(SDL::WM::GRAB_ON)
SDL::Mouse.hide
#g.bg_color=[0.2,0.2,0.2,0.0]
g.light.on=true
g.lighting=true

g.cam.front=Vec.new([0,0,-1])
g.cam.up=Vec.new([0,1,0])

g.start do
	hud.current_fps = g.current_fps.to_i
	hud.lighting = g.lighting?
end
