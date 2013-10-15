require 'stringio'

class T
    class << self
        attr_accessor :xd
    end
    @@xd = 10
    def test
        puts @@xd
    end
end

class P < T
    def test
        puts @@xd
    end
    def self.xd=(xd)
        @@xd = xd
    end
end

t = T.new
p = P.new
t.test          # this will puts 10
p.test          # 10, too
T.xd = 5
t.test
p.test
P.xd = 7
t.test
p.test

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