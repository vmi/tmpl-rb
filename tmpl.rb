#!/usr/bin/ruby

# Copyright 2014  Motonori IWAMURO
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works
# is notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

require 'erb'

class Tmpl
  def initialize(file: nil, text: nil)
    text = IO.read(file) if text.nil?
    @erb = ERB.new(text, nil, '%-')
    @erb.filename = file
    @context = Object.new
    @map = map = {}
    @context.define_singleton_method(:method_missing) do |method, *args|
      map[method]
    end
    class << @context
      include ERB::Util
    end
  end

  def set(hash)
    hash.each { |key, value| set(key, value) } if hash
    self
  end

  def set(key, value)
    key = key.to_sym
    if @context.respond_to? key
      raise "Can't use the key name: #{key}"
    end
    @map[key] = value
    self
  end

  def result
    erb = @erb
    @context.instance_eval do
      erb.result(binding)
    end
  end

end

if $0 == __FILE__
  if ARGV.length == 0
    print <<-EOF
Usage: #{$0} [-o OUTFILE] INFILE KEY1=VALUE1 ...
    EOF
    exit 1
  end
  ofile = nil
  if ARGV[0] == '-o'
    ARGV.shift
    ofile = ARGV.shift
  end
  ifile = ARGV.shift
  tmpl = Tmpl.new(file: ifile)
  ARGV.each do |arg|
    key, value = *arg.split(/=/, 2)
    tmpl.set(key, value)
  end
  if ofile
    open(ofile, 'w') do |io|
      io.print tmpl.result
    end
  else
    print tmpl.result
  end
end
