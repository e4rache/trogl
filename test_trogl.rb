#!/usr/bin/ruby

require "lib/trogl.rb"

g = Trogl::Scene.new(800,600,70,".oO Trogl Oo.")	# create window ( width, height, fov )
# create a textured cube and set it's position
cube_tex = Trogl::Object3d::CubeTex.new()
cube_tex.pos=[-3,0,0]

# load a wavefront object (.obj) with a scale factor

#wf_test = WaveFront.new("data/obj/calaca_uvm.obj",0.05)
#wf_test = WaveFront.new("data/obj/chain.obj",0.05)
#wf_test = WaveFront.new("data/obj/rock.obj",0.05)
#wf_test = WaveFront.new("data/obj/rock2.obj",0.8)
#wf_test = WaveFront.new("data/obj/dragon-1500.obj",1)
#wf_test = WaveFront.new("data/obj/dragoon.obj",0.2)
#wf_test = WaveFront.new("data/obj/sapin.obj",0.5)
#wf_test = WaveFront.new("data/obj/mug.obj",0.5)
#wf_test = WaveFront.new("data/obj/toyplane.obj",0.05)
wf_test = Trogl::Object3d::Loader::WaveFrontObject.new("data/obj/diatomee.obj",0.5)
#wf_test = WaveFront.new("data/obj/bone.obj",0.05)
wf_test.pos=[3,1,0]

# sets some params in trogl
g.draw_axis=true
g.target_fps=30

# add the loaded objects to trogl
g.entities.push(cube_tex)
g.entities.push(wf_test)

# some key bindings
anim_obj = g.cam
g.bind_key(SDL::Key::LEFT   , Proc.new {g.cam_angle+=2} )
g.bind_key(SDL::Key::RIGHT  , Proc.new {g.cam_angle-=2} )
g.bind_key(SDL::Key::Q      , Proc.new { exit } )
g.bind_key(SDL::Key::S		, Proc.new {anim_obj.rot_x(0.04)} )
g.bind_key(SDL::Key::W		, Proc.new {anim_obj.rot_x(-0.04)} )
g.bind_key(SDL::Key::A		, Proc.new {anim_obj.rot_y(0.04)} )
g.bind_key(SDL::Key::D		, Proc.new {anim_obj.rot_y(-0.04)} )
g.bind_key(SDL::Key::Z		, Proc.new {anim_obj.rot_z(-0.04)} )
g.bind_key(SDL::Key::C		, Proc.new {anim_obj.rot_z(0.04)} )
g.bind_key(SDL::Key::F		, Proc.new {anim_obj.forward(0.1)} )
g.bind_key(SDL::Key::V		, Proc.new {anim_obj.forward(-0.1)} )
g.bind_key(SDL::Key::F1		, Proc.new {anim_obj = cube_tex} )
g.bind_key(SDL::Key::F2		, Proc.new {anim_obj = wf_test} )
g.bind_key(SDL::Key::F3		, Proc.new {anim_obj = g.cam } )
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

SDL::WM::grab_input(SDL::WM::GRAB_ON)
SDL::Mouse.hide

# tell trogl to rumble
g.start do
# put something here that needs to be computed after each frame
end
