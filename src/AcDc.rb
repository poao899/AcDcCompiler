#!/usr/bin/env ruby

load 'ASTNode.rb'
load 'AcDcScanner.rb'

class AcDcCompiler

    def initialize(argv)
        raise "can't open the source file\n" unless File.readable? argv[0]
        @source = File.open(argv[0], "r")
        @target = File.open(argv[1], "w")
        @scanner = Scanner.new(@source)
        @token_list = []
    end
    
    def parse
        while token = @scanner.getToken
            @token_list.push(token)
            token.test
        end
        test = TestNode.new(@token_list)
        test.parse
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
        myAcDc.parse
    
    rescue Exception => e    # Compile failed.
        puts e.message
    end
    
end

main if __FILE__ == $0        # The entry of this program
