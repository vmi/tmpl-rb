Tmpl
====

This is the tiny template engine based on ERB.

Usage1: command line
--------------------

    Usage: tmpl.rb [-o OUTFILE] INFILE KEY1=VALUE1 KEY2=VALUE2 ...


Usage2: library
---------------

* ruby code

        require 'tmpl'
        
        tmpl = Tmpl.new("infile.erb")
        tmpl.set("key1", "value1")
        tmpl.set("key2", "value2")
        print tmpl.result

* template file

        key1 = <%= @key1 %>
        key2 = <%= @key2 %>

License
-------

Fair License.

see http://opensource.org/licenses/fair
