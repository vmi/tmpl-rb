#!/usr/bin/ruby -I.

require 'minitest/unit'
require 'tmpl'

include MiniTest

Unit.autorun

class TestTmpl < Unit::TestCase
  def test_tmpl
    tmpl = Tmpl.new(file: "test.erb")
    tmpl.set('test1', 'value1')
    tmpl.set('test2', '<>&"')
    result = tmpl.result
    $stderr.puts result
    assert_equal(tmpl.result, <<-EOF)
var test1 = value1
var test2 = &lt;&gt;&amp;&quot;
var test2_2 = 'test2 assigned'
var test3 = 'test3 assigned'
    EOF
  end
end
