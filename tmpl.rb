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
  def initialize(file)
    tmpl = IO.read(file)
    @erb = ERB.new(tmpl, nil, '%-')
    @erb.filename = file
    @context = Object.new
    class << @context
      include ERB::Util
    end
  end

  def set(hash)
    hash.each { |key, value| set(key, value) } if hash
    self
  end

  def set(key, value)
    @context.instance_variable_set('@' + key, value)
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
  tmpl = Tmpl.new(ifile)
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
