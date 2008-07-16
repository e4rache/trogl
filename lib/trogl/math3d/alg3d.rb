#!/usr/bin/ruby

#$:.unshift File.dirname(__FILE__) unless
#  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "trogl/math3d/alg3d/float.rb"
require "trogl/math3d/alg3d/vec.rb"
require "trogl/math3d/alg3d/quat.rb"

=begin
#### active_record

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

unless defined? ActiveSupport
  active_support_path = File.dirname(__FILE__) + "/../../activesupport/lib"
  if File.exist?(active_support_path)
    $:.unshift active_support_path
    require 'active_support'
  else
    require 'rubygems'
    gem 'activesupport'
    require 'active_support'
  end
end

require 'active_record/base'
require 'active_record/observer'
require 'active_record/query_cache'


=========================================================

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

===========================================================



=end

