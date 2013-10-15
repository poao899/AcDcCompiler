#!/usr/bin/env ruby

load 'ASTNodes.rb'
load 'AcDcScanner.rb'

class AcDcCompiler

    def initialize(argv)
        raise "can't open the source file\n" unless File.readable? argv[0]
        @source_file = File.open(argv[0], "r")
        @target_file = File.open(argv[1], "w")
        @scanner = Scanner.new(@source_file)
        @token_list = []
        @syntax_tree = nil
    end
    
    def get_input
        while token = @scanner.getToken
            @token_list.push(token)
        end
        @token_list.push(Token.new(:T_eof))
    end 

    def parse
        @syntax_tree = Prog.new(@token_list)
        @syntax_tree.parse
    end
    
    def code_generate
        #result = @syntax_tree.code_generate 
        #puts result
        # TODO: output to target_file
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
        myAcDc.get_input
        myAcDc.parse
        myAcDc.code_generate 
    rescue Exception => e    # Compile failed.
        puts e.message
    end
    
end

main if __FILE__ == $0        # The entry of this program
