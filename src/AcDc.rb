#!/usr/bin/env ruby

class ASTNode
	
	def initialize
		@next = Hash.new
	end
	
end

class AcDcCompiler

	def initialize(argv)
		raise "can't open the source file\n" unless File.readable? (argv[0])
		@source = File.open(argv[0], "r")
		@target = File.open(argv[1], "w")
	end
	
end

###################################
# The entry of the AcDc compiler  #
# return the message immediately  #
###################################

def main

	begin

		raise "Usage: #{$0} source_file target_file" unless ARGV.length == 2

		myAcDc = AcDcCompiler.new(ARGV)
		
		myAcDc.test
	
    rescue Exception => e	# Compile failed.
		puts e.message
	end
	
end

main if __FILE__ == $0		# The entry of this program