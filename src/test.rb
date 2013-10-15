require 'stringio'

class TreeNode

	def initialize
		@next = Hash.new
	end
	
	def insert(key, val)
		@next[key] = val
	end
	
	def trace
		puts "Now at #{self.class.name}"
		@next.each_value{|v| v.trace}
	end
end

def test e
	puts e.class.name
end

class Node1 < TreeNode
	def initialize
		super
	end
end

s = "a = 1+2 sdf.3	 * 3.536.6"
s2 = s.scan(/(\w+\.*)|([\+\-\*\/\=]+)/)
s2.each{|x| puts "#{x} QQ"}

=begin
root = Node1.new
ch = TreeNode.new
root.insert(:c1, ch)
root.trace

test root
test ch
=end