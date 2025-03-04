#!/usr/bin/ruby


v_tot = 1
vqty = 0

file = ARGV.shift
f = File.new(file, "rb")

while ! f.eof?
   cid = f.read(2).unpack('s')[0] 
   len = f.read(4).unpack('i')[0]
   #puts "# len=#{ len.inspect }"
   case cid
   when 0x4d4d
      puts "# MAIN CHUNK"
      next

   when 0x3d3d
      puts "#  3D EDITOR CHUNK"
      next

   when 0x4000
      puts "#   OBJECT BLOCK : "
      name = ""
      20.times do 
	 c = f.read(1)
	 break if c == "\000"
	 c =  c.unpack('C')[0].chr
	 name << c
      end
      puts "g #{name}"
      next

   when 0x4100
      next

   when 0x4110
      print "#     VERTICES LIST: "
      vqty = f.read(2).unpack('s')[0]
      puts "(#{ vqty.inspect })"
      vqty.times do 
	 x = f.read(4).unpack('f')[0]
	 y = f.read(4).unpack('f')[0]
	 z = f.read(4).unpack('f')[0]
	 str = "v #{x} #{y} #{z}"
	 #print v_tot," "
	 puts str
	 v_tot += 1
      end
      next

   when 0x4120
      print "#  FACES"
      qty = f.read(2).unpack('s')[0]
      puts "(#{ qty.inspect })"
      qty.times do 
	 a = f.read(2).unpack('s')[0]
	 b = f.read(2).unpack('s')[0]
	 c = f.read(2).unpack('s')[0]
	 flags = f.read(2).unpack('s')[0]
	 str =  "f #{v_tot-vqty+a} #{v_tot-vqty+b} #{v_tot-vqty+c}"
	 puts str
      end
      next

   else
      f.seek(len-6, IO::SEEK_CUR)
   end

end

f.close

