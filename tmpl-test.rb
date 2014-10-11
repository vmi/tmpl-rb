#!/usr/bin/ruby -I.

require 'minitest/unit'
require 'tmpl'

include MiniTest

Unit.autorun

class TestTmpl < Unit::TestCase
  def test_tmpl
    tmpl = Tmpl.new("test.erb")
    tmpl.set('test1', 'value1')
    tmpl.set('test2', '<>&"')
    assert_equal(tmpl.result, <<-EOF)
var test1 = value1
var test2 = &lt;&gt;&amp;&quot;
    EOF
  end
end
